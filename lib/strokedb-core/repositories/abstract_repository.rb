module StrokeDB
  module Core
    module Repositories
      # Store operations: POST,   GET,  PUT,    DELETE
      #                  (CREATE, READ, UPDATE, DELETE)
      #
      # Different pieces of functionality are implemented as independent modules.
      # You should create your own repository class and extend it with all 
      # the modules you need (in the correct order!). See ClassFactory.
      #
      # Built-in modules overview:
      #   AbstractRepository      Defines all the methods with empty bodies. 
      #   AbstractAsyncRepository Defines all the callbacks for async interfaces.
      #   TokyoCabinetRepository  Defines operations using TokyoCabinet API
      #   MarshalHelper           Defines encode_doc/decode_doc using Marshal.dump/load.
      #   JsonHelper              Defines encode_doc/decode_doc using JSON format.
      #   ProxyRepository         Defines an asynchronous proxy to a cluster of nodes.
      #   etc.
      #
      # Note: these methods are left blank to be a safe fallback for super call.
      #
      module AbstractRepository
        include AbstractHelpers
        
        # Opens database (options is a Hash).
        def open(options)
        end
      
        # Closes database (file, connection, etc.).
        def close
        end
      
        # Returns a document by version.
        def get_version(version)
        end

        # Returns the latest version for the given UUID.
        def head(uuid)
        end

        # Returns a document.
        def get(uuid)
        end

        # Adds "uuid", "version" fields to a hash before save.
        # Returns a [uuid, version].
        def post(doc)
        end

        # Sets "previous_version" := "version", "version" := new version before save.
        # Returns version.
        def put(uuid, doc)
        end

        # Mostly the same as put()
        # Saves {deleted: true} version, removes document from indexes.
        # Returns version.
        def delete(uuid)
        end
        
        # Vanishes the storage.
        def vanish
        end
        
        # Syncs repository updates with the device.
        def sync
        end
        
        # Returns number of versions in a repository.
        def versions_count
        end
        
        # Returns number of UUIDs stored in a repository.
        def uuids_count
        end
        
        # Iterates over each UUID.
        # Returns self if block is supplied, iterator instance otherwise.
        def each_uuid(&block)
        end
        
        # Iterates over each version.
        # Returns self if block is supplied, iterator instance otherwise.
        # Note: in general, versions are not grouped by UUID!
        def each_version(&block)
        end
        
        # Returns new iterator for uuids.
        def new_uuids_iterator
        end
        
        # Returns new iterator for versions.
        def new_versions_iterator
        end
        
      end
    end # Repositories
  end # Core
end # StrokeDB
