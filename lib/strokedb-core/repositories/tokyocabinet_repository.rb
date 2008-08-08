require 'tokyocabinet'

module StrokeDB
  module Core
    module Repositories
      module TokyoCabinetRepository
        include TokyoCabinet
        attr_reader :uuid
        attr_reader :tc_path
        attr_reader :tc_storage_path, :tc_heads_path, :tc_log_path
        attr_reader :tc_storage,      :tc_heads,      :tc_log
        
        REPO_UUID_TOKEN = "STROKEDB REPOSITORY UUID"
        
        # Opens a repository.
        # Class uses 3 files:
        # * storage -- a list of (version -> contents) pairs
        # * heads -- a list of (uuid -> head version) pairs
        # * log -- a list of (uuid, timestamp)
        def open(options)
          OptionsHash!(options)
          @tc_path         = options.require("path")
          @tc_storage_path = options["storage_path"] || (@tc_path + ".versions")
          @tc_heads_path   = options["heads_path"] || (@tc_path + ".heads")
          @tc_log_path     = options["log_path"] || (@tc_path + ".log")
          @tc_storage = HDB::new
          @tc_heads   = HDB::new
          @tc_log     = BDB::new
          mode    = HDB::OWRITER | HDB::OCREAT
          bdbmode = BDB::OWRITER | BDB::OCREAT 
          @tc_storage.open(@tc_storage_path, mode) or tc_raise("open", @tc_storage_path, mode)
          @tc_heads.open(@tc_heads_path, mode)     or tc_heads_raise("open", @tc_heads_path, mode)
          # FIXME: i don't really  think we need this log file right now.
          @tc_log.open(@tc_log_path, bdbmode)      or tc_log_raise("open", @tc_log_path, bdbmode)
          # REFACTOR THIS
          # TODO: save repo uuid into the versions storage at the very top and ignore in the iterator.
          # brand new repository -> generate UUID for it
          if @tc_log.size == 0
            @uuid = generate_uuid(nil)
            @tc_log.put(REPO_UUID_TOKEN, @uuid)
          else
            @uuid = @tc_log.get(REPO_UUID_TOKEN) or tc_log_raise("get", REPO_UUID_TOKEN)
          end
          nil
        end
      
        # Closes repository
        def close
          @tc_storage.close or tc_raise("close")
          @tc_heads.close or tc_heads_raise("close")
          @tc_log.close or tc_log_raise("close")
          nil
        end

        # Returns the latest version for the given UUID
        def head(uuid, repo_uuid = @uuid)
          @tc_heads.get(uuid + repo_uuid)
        end
        
        # Returns a document or nil if not found
        def get_version(version)
          decode_doc(@tc_storage.get(version))
        end
        
        # Returns a list of documents or an empty array if nothing found
        def get_versions(versions)
          versions.map {|v| [v,get_version(v)] }
        end
        
        def has_version?(version)
          @tc_storage.has_key?(version)
        end

        # Returns a document or nil if not found
        def get(uuid, repo_uuid = @uuid)
          # Note:
          # We do not call head(uuid) here because it might be 
          # a completely different method in a stack of modules.
          # For refactoring purposes you must use custom private
          # methods with some module-specific prefix 
          # (like "tc_" for tokyocabinet)
          version = @tc_heads.get(uuid + repo_uuid) or return nil
          decode_doc(@tc_storage.get(version))
        end

        # TODO: refactor this into separate layer
        # Returns ancestors for 
        def ancestors(versions)
          versions.inject([]) do |ancestors, version|
            ancestors + tc_previous_versions(version)
          end
        end
        
        # TODO: refactor this into separate layer
        # Fetches document's updates from the specified repository
        def fetch(uuid, repo, repo_uuid = nil)
          repo_uuid ||= repo.uuid
          missing_versions = [repo.head(uuid, repo_uuid)].compact
          while true
            missing_versions = missing_versions.select do |mv|
              !has_version?(mv)
            end
            break if missing_versions.empty?
            docs = repo.get_versions(missing_versions)
            docs.each do |v,doc|
              store(v, uuid, doc, repo_uuid)
            end
            missing_versions = repo.ancestors(missing_versions)
          end
        end

        # TODO: refactor this into separate layer
        # We try to find the latest HEAD
        def push(uuid, repo, from_repo_uuid = nil, to_repo_uuid = nil)
          from_repo_uuid ||= @uuid
          to_repo_uuid ||= repo.uuid
          remote_head = repo.head(uuid, to_repo_uuid)
          # TODO: receiver must store received versions somewhere, 
          #       then try fast-forward merge or report an error.
          #       Find out what this "somewhere" is. Maybe, a temporary
          #       repo/branch.
        end
        
        # TODO: refactor this into separate layer
        # Merges a document from the specified repo branch to the current branch
        def merge(uuid, repo_uuid)
          v1 = head(uuid, @uuid)
          v2 = head(uuid, repo_uuid)
          ca = common_ancestor(v1, v2)
          
          
        end
  
        
        # Stores doc in a repository. Returns nil.
        def store(version, uuid, doc, repo_uuid = @uuid)
          encoded_doc = encode_doc(doc)
          @tc_storage.put(version, encoded_doc) or tc_raise("put", version, encoded_doc)
          @tc_heads.put(uuid + repo_uuid, version) or tc_heads_raise("put", uuid, version)
          nil
        end
        
        # Vanishes the storage
        def vanish
          @tc_storage.vanish or tc_raise("vanish")
          @tc_heads.vanish or tc_heads_raise("vanish")
          @tc_log.vanish or tc_log_raise("vanish")
          nil
        end
        
        # Syncs repository updates with the device
        def iosync
          @tc_storage.sync or tc_raise("sync")
          @tc_log.sync or tc_log_raise("sync")
          @tc_heads.sync or tc_heads_raise("sync")
          nil
        end
        
        # Returns number of versions in a repository
        def versions_count
          @tc_storage.size
        end
        
        # Returns number of UUIDs stored in a repository
        def heads_count
          @tc_heads.size or tc_heads_raise("uuids_count")
        end

        def each_head(&blk)
          return Iterators::UuidsIterator.new(self) unless block_given?
          hdb = @tc_storage
          uuid_size = generate_uuid(nil).size
          @tc_heads.each do |uuid_repouuid, version|
            uuid = uuid_repouuid[0, uuid_size]
            repo_uuid = uuid_repouuid[uuid_size, uuid_size]
            yield(uuid, repo_uuid, decode_doc(hdb.get(version)))
          end
          self
        end

        def each_version(&blk)
          return Iterators::VersionsIterator.new(self) unless block_given?
          @tc_storage.each do |version, encoded_doc|
            yield(version, decode_doc(encoded_doc))
          end
          self
        end
        
        class StorageError < Exception; end
      
      private
        
        # oleganza: 
        # Private methods are prefixed to avoid clashing with other modules' private helpers.
        # Now I understand why private members in C++ are not shared in the inheritance chain.
        
        def tc_raise(meth, *args)
          ecode = @tc_storage.ecode
          argsi = args.map{|a|a.inspect}.join(', ')
          raise(StorageError, "TokyoCabinet::HDB##{meth}(#{argsi}) error: %s\n" % @tc_storage.errmsg(ecode))
        end
        
        def tc_heads_raise(meth, *args)
          ecode = @tc_heads.ecode
          argsi = args.map{|a|a.inspect}.join(', ')
          raise(StorageError, "TokyoCabinet::HDB(uuids index)##{meth}(#{argsi}) error: %s\n" % @tc_heads.errmsg(ecode))
        end
        
        def tc_log_raise(meth, *args)
          ecode = @tc_log.ecode
          argsi = args.map{|a|a.inspect}.join(', ')
          raise(StorageError, "TokyoCabinet::BDB(log)##{meth}(#{argsi}) error: %s\n" % @tc_log.errmsg(ecode))
        end
        
        def tc_previous_versions(version)
          # TODO: make an index for this stuff
          v = get_version(version)["previous_version"]
          if v
            Array === v ? v : [v]
          else
            []
          end
        end
        
      end
    end # Repositories
  end # Core
end # StrokeDB
