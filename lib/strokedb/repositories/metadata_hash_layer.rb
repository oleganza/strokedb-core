module StrokeDB
  module Repositories
    module MetadataHashLayer
      Cuuid             = "uuid".freeze
      Cversion          = "version".freeze
      Cprevious_version = "previous_version".freeze
      
      # Adds "version" fields to a hash before save.
      # Returns version
      def put(doc)
        # Operation order is important (surprise!): generate_version() 
        # may rely on document contents.
        uuid    = doc[Cuuid]
        version = doc[Cversion]
        doc[Cprevious_version] = version if version
        version       = generate_version(doc)
        doc[Cversion] = version
        store(version, uuid, doc)
        version
      end
      
    end
  end # Repositories
end # StrokeDB
