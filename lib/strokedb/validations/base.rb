module StrokeDB
  module Validations
    module Base
      include Declarations
      
      def register_validation(validation)
        local_declarations(:validations, []) do |list|
          list << validation
        end
      end
      
      def validations
        inherited_declarations(:validations) do |inherited_data|
          inherited_data.inject([]) do |vs, local_vs|
            vs + local_vs
          end
        end
      end
      
    end # Base
  end # Validations
end # StrokeDB
