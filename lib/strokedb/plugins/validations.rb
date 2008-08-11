module StrokeDB
  module Plugins
    class Validations < Plugin

      module ClassMethods
        attr_accessor :validations
        def validates_presence_of(*args)
          @validations << [:presence_of, args]
        end
        alias validate_presence_of validates_presence_of # nobody likes stupid typos
        
        def strokedb_configured(*args)
          super
          @validations = []
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
