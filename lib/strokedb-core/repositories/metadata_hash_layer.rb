require 'tokyocabinet'

module StrokeDB
  module Core
    module Repositories
      module MetadataHashLayer
        Cuuid             = "uuid".freeze
        Cversion          = "version".freeze
        Cprevious_version = "previous_version".freeze
        
        # Adds "uuid", "version" fields to a hash before save
        # Returns an uuid
        def post(doc)
          uuid          = generate_uuid(doc)
          version       = generate_version(doc)
          doc[Cuuid]    = uuid
          doc[Cversion] = version
          store(version, uuid, doc)
          [uuid, version]
        end

        # Sets "previous_version" := "version", "version" := new version before save
        # Returns nil
        def put(uuid, doc)
          version                = generate_version(doc)
          doc[Cprevious_version] = doc[Cversion]
          doc[Cversion]          = version
          store(version, uuid, doc)
          nil
        end

        # Mostly same as put()
        # Saves {deleted: true} version, removes document from indexes
        # Returns nil
        def delete(uuid, doc)
          doc2                    = new_deleted_document
          doc2[Cversion]          = generate_version(doc)
          doc2[Cprevious_version] = doc[Cversion]
          store(version, uuid, doc)
          nil
        end
        
      end
    end # Repositories
  end # Core
end # StrokeDB
