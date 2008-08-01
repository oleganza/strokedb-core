require 'tokyocabinet'

module StrokeDB
  module Core
    module Repositories
      module TokyoCabinetRepository
        include TokyoCabinet
        attr_accessor :tc_path, :tc_path_index, :tc_hdb,  :tc_hdb_index
        
        # Opens a database (options is an OptionsHash)
        def open(options)
          OptionsHash!(options)
          @tc_path = options.require("path")
          @tc_path_index = options["path_index"] || (@tc_path + ".uuidindex")
          @tc_hdb = HDB::new
          @tc_hdb_index = HDB::new
          mode = HDB::OWRITER | HDB::OCREAT
          @tc_hdb.open(@tc_path, mode) or tc_raise("open", @tc_path, mode)
          @tc_hdb_index.open(@tc_path_index, mode) or tc_raise("index.open", @tc_path_index, mode)
          nil
        end
      
        # Closes database
        def close
          @tc_hdb.close or tc_raise("close")
          @tc_hdb_index.close or tc_raise("index.close")
          nil
        end

        # Returns the latest version for the given UUID
        def head(uuid)
          @tc_hdb_index.get(uuid)
        end
        
        # Returns a document or nil if not found
        def get_version(version)
          @tc_hdb.get(version)
        end

        # Returns a document or nil if not found
        def get(uuid)
          # We do not call head(uuid) here because it might be 
          # a completely different method in a stack of modules.
          # For refactoring purposes you must use custom private
          # methods with some module-specific prefix 
          # (like "tc_" for tokyocabinet)
          version = @tc_hdb_index.get(uuid) or return nil
          @tc_hdb.get(version)
        end

        # Adds "uuid", "version" fields to a hash before save
        # Returns an uuid
        def post(doc)
          uuid          = generate_uuid(doc)
          version       = generate_version(doc)
          doc[Cuuid]    = uuid
          doc[Cversion] = version
          encoded_doc   = encode_doc(doc)
          
          tc_store(version, uuid, encoded_doc)
          uuid
        end

        # Sets "previous_version" := "version", "version" := new version before save
        # Returns nil
        def put(uuid, doc)
          version                = generate_version(doc)
          doc[Cprevious_version] = doc[Cversion]
          doc[Cversion]          = version
          encoded_doc            = encode_doc(doc)
          
          tc_store(version, uuid, encoded_doc)
          nil
        end

        # Mostly same as put()
        # Saves {deleted: true} version, removes document from indexes
        # Returns nil
        def delete(doc)
          doc2                    = new_deleted_document
          doc2[Cversion]          = generate_version(doc)
          doc2[Cprevious_version] = doc[Cversion]
          encoded_doc             = encode_doc(doc2)
          
          tc_store(version, uuid, encoded_doc)
          nil
        end
        
        # Vanishes the storage
        def vanish
          @tc_hdb.vanish or tc_raise("vanish")
          @tc_hdb_index.vanish or tc_raise("index.vanish")
          nil
        end
        
        # Syncs repository updates with the device
        def sync
          @tc_hdb.sync or tc_raise("sync")
          @tc_hdb_index.sync or tc_raise("index.sync")
          nil
        end

      private
        
        # Methods are prefixed to avoid clashing with other modules' private helpers.
        def tc_store(version, uuid, encoded_doc)
          @tc_hdb.put(version, encoded_doc) or tc_raise("put", version, encoded_doc)
          @tc_hdb_index.put(uuid, version) or tc_raise("index.put", uuid, version)
        end
        
        def tc_raise(meth, *args)
          ecode = @tc_hdb.ecode
          argsi = args.map{|a|a.inspect}.join(', ')
          raise("TokyoCabinet::HDB##{meth}(#{argsi}) error: %s\n" % @tc_hdb.errmsg(ecode))
        end
        
      end
    end # Repositories
  end # Core
end # StrokeDB
