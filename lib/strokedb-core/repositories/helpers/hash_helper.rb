module StrokeDB
  module Repositories
    module HashHelper

      def new_document
        { "uuid" => generate_uuid(nil) }
      end

    end
  end # Repositories
end # StrokeDB
