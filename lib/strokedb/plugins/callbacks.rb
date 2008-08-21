module StrokeDB
  module Plugins
    module Callbacks
      include Plugin
      
      module ClassMethods
        attr_accessor :callbacks
        def before_save(*args)
          @callbacks ||= { }
          @callbacks[:before_save] ||= []
          @callbacks[:before_save] << args
        end
      end
      
      module InstanceMethods
        def save
          p self.class.callbacks
          super
        end
      end
      
    end
  end
end
