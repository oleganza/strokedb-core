module StrokeDB
  module Core
    module Repositories
      module DefaultUuidHelpers
        # TODO: use raw uuids, maybe add encode/decode methods for uuid
        def generate_version(doc)
          Util::random_uuid
        end
        
        def generate_uuid(doc)
          Util::random_uuid
        end
      end
    end # Repositories
  end # Core
end # StrokeDB
