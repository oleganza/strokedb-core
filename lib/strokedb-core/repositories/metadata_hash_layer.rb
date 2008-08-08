module StrokeDB
  module Core
    module Repositories
      module MetadataHashLayer
        Cuuid             = "uuid".freeze
        Cversion          = "version".freeze
        Cprevious_version = "previous_version".freeze
        
        # Adds "version" fieldsto a hash before save.
        # Operation order is important (surprise!): generate_version() 
        # may rely on document contents.
        # Returns version
        def post(doc)
          uuid          = doc[Cuuid]
          version       = generate_version(doc)
          doc[Cversion] = version
          store(version, uuid, doc)
          version
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
        
      end
    end # Repositories
  end # Core
end # StrokeDB
