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
      
        # Returns repo's UUID
        def uuid
        end
        
        # Returns a document by version.
        def get_version(version)
        end

        # Returns the latest version for the given UUID.
        def head(uuid)
        end

        # Returns a HEAD version document.
        def get(uuid)
        end

        # Stores doc in a repository tagged with version & uuid arguments. 
        # Returns nil.
        def store(version, uuid, doc)
        end
        
        # Adds "uuid", "version" fields to a hash before save.
        # Returns a version.
        def put(doc)
        end

        # Vanishes the storage.
        def vanish
        end
        
        # Syncs repository updates with the device.
        def iosync
        end
        
        # Returns number of versions in a repository.
        def versions_count
        end
        
        # Returns number of UUIDs stored in a repository.
        def heads_count
        end
        
        # Iterates over each UUID.
        # Returns self if block is supplied, iterator instance otherwise.
        def each_head(&block)
        end
        
        # Iterates over each version.
        # Returns self if block is supplied, iterator instance otherwise.
        # Note: in general, versions are not grouped by UUID!
        def each_version(&block)
        end
        
      end
    end # Repositories
  end # Core
end # StrokeDB
