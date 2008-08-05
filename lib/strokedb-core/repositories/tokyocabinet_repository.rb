require 'tokyocabinet'

module StrokeDB
  module Core
    module Repositories
      module TokyoCabinetRepository
        include TokyoCabinet
        attr_accessor :tc_path, :tc_storage_path, :tc_heads_path, :tc_log_path
        attr_accessor           :tc_storage,      :tc_heads,      :tc_log
        
        # Opens a repository
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
          @tc_log.open(@tc_log_path, bdbmode)      or tc_log_raise("open", @tc_log_path, bdbmode)
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
        def head(uuid)
          @tc_heads.get(uuid)
        end
        
        # Returns a document or nil if not found
        def get_version(version)
          decode_doc(@tc_storage.get(version))
        end

        # Returns a document or nil if not found
        def get(uuid)
          # Note:
          # We do not call head(uuid) here because it might be 
          # a completely different method in a stack of modules.
          # For refactoring purposes you must use custom private
          # methods with some module-specific prefix 
          # (like "tc_" for tokyocabinet)
          version = @tc_heads.get(uuid) or return nil
          decode_doc(@tc_storage.get(version))
        end
        
        # Stores doc in a repository. Returns nil.
        def store(version, uuid, doc)
          encoded_doc = encode_doc(doc)
          @tc_storage.put(version, encoded_doc) or tc_raise("put", version, encoded_doc)
          @tc_heads.put(uuid, version) or tc_heads_raise("put", uuid, version)
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
        def sync
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
          @tc_heads.each do |uuid, version|
            yield(uuid, decode_doc(hdb.get(version)))
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
      end
    end # Repositories
  end # Core
end # StrokeDB
