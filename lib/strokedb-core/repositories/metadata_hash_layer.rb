module StrokeDB
  module Core
    module Repositories
      module MetadataHashLayer
        Cuuid             = "uuid".freeze
        Cversion          = "version".freeze
        Cprevious_version = "previous_version".freeze
        
        # Adds "uuid", "version" fields to a hash before save.
        # Operation order is important (surprise!): generate_version() 
        # may rely on document contents.
        # Returns [uuid, version]
        def post(doc)
          uuid          = generate_uuid(doc)
          doc[Cuuid]    = uuid
          version       = generate_version(doc)
          doc[Cversion] = version
          store(version, uuid, doc)
          [uuid, version]
        end

        # Sets "previous_version" := "version", "version" := new version before save
        # Returns version
        def put(uuid, doc)
          doc[Cprevious_version] = doc[Cversion]
          version                = generate_version(doc)
          doc[Cversion]          = version
          store(version, uuid, doc)
          version
        end

        # Mostly same as put()
        # Saves {deleted: true} version, removes document from indexes
        # Returns version
        def delete(uuid, doc)
          doc2                    = new_deleted_document(doc)
          doc2[Cprevious_version] = doc[Cversion]
          version                 = generate_version(doc2)
          doc2[Cversion]          = version
          store(version, uuid, doc2)
          version
        end
        
      end
    end # Repositories
  end # Core
end # StrokeDB
