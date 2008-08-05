require 'tokyocabinet'

module StrokeDB
  module Core
    module Repositories
      module OnMemoryRepository
        attr_reader :uuid
        attr_accessor :ram_versions, :ram_heads
        
        # Opens a repository
        def open(options)
          @ram_versions = Hash.new
          @ram_heads    = Hash.new
          @uuid = generate_uuid(nil)
          nil
        end
      
        # Closes repository
        def close
          @ram_versions = nil
          @ram_heads    = nil
          nil
        end

        # Returns the latest version for the given UUID
        def head(uuid, ruuid = @uuid)
          @ram_heads[uuid + ruuid]
        end
        
        # Returns a document or nil if not found
        def get_version(version)
          decode_doc(@ram_versions[version])
        end

        # Returns a document or nil if not found
        def get(uuid, ruuid = @uuid)
          version = @ram_heads[uuid + ruuid] or return nil
          decode_doc(@ram_versions[version])
        end
        
        # Stores doc in a repository. Returns nil.
        def store(version, uuid, doc)
          encoded_doc = encode_doc(doc)
          @ram_versions[version] = encoded_doc
          @ram_heads[uuid + @uuid] = version
          nil
        end
        
        # Vanishes the storage
        def vanish
          @ram_versions.clear
          @ram_heads.clear
          nil
        end
        
        # Syncs repository updates with the device
        def device_sync
          nil
        end
        
        # Returns number of versions in a repository
        def versions_count
          @ram_versions.size
        end
        
        # Returns number of UUIDs stored in a repository
        def heads_count
          @ram_heads.size
        end

        def each_head(&blk)
          # TODO: each_uuid(&blk)
        end

        def each_version(&blk)
          # TODO: each_version(&blk)
        end
        
      end
    end # Repositories
  end # Core
end # StrokeDB
