module StrokeDB
  module Validations
    module ClassMethods
      def register_validation(validation)
        @validations ||= []
        @validations << validation
      end
      
      # per-module validations, inheritance chain is not looked up.
      def local_validations
        @validations
      end
      
      # Inherit all the validations
      def validations
        ancestors.inject([]) do |validations, mod|
          validatable?(mod) ? validations + mod.local_validations : validations
        end
      end
            
    private
      def validatable?(mod)
        mod != Validations && mod.ancestors.include?(Validations)
      end
      
    end # ClassMethods
  end # Validations
end # StrokeDB
