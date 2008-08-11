module StrokeDB
  module Plugins
    class Callbacks < Plugin
      
      module ClassMethods
        attr_accessor :callbacks
        def before_save(*args)
          @callbacks[:before_save] << args
        end
        
        def strokedb_configured(*args)
          super
          @callbacks = [:before_save].inject({}){|c,e| c[e] = []; c }
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
