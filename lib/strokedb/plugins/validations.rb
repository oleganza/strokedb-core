module StrokeDB
  module Plugins
    module Validations
      include Plugin
      module ClassMethods
        def validates_presence_of(slot, *args)
          # TODO: check the args
          register_validation(:presence_of, slot, *args)
        end
        alias validate_presence_of validates_presence_of # nobody likes stupid typos
        
        def register_validation(name, slot, *args)
          @validations ||= []
          @validations << [name, slot, *args]
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
      end
      
      module InstanceMethods
        def save
          p self.class.validations
          super
        end
      end
      
    end
  end
end
