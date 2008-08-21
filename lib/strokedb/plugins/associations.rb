module StrokeDB
  module Plugins
    module Associations
      include Plugin
      
      module ClassMethods
        attr_accessor :associations
        def has_many(*args)
          @associations ||= []
          @associations << [:has_many, args]
        end
      end
      
      module InstanceMethods
        def save
          p self.class.associations
          super
        end
      end
      
    end
  end
end
