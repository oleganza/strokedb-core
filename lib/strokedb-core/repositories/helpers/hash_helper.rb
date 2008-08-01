module StrokeDB
  module Core
    module Repositories
      module HashHelper

        def new_empty_document
          { }
        end
        
        def new_deleted_document
          { Cdeleted => true }
        end
      end
    end # Repositories
  end # Core
end # StrokeDB