module StrokeDB
  module Core
    module Repositories
      module HashHelper

        def new_document
          { "uuid" => generate_uuid(nil) }
        end

      end
    end # Repositories
  end # Core
end # StrokeDB
