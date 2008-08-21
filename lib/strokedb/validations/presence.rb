module StrokeDB
  module Validations
    module ClassMethods
      def validates_presence_of(slot, *args)
        # TODO: check the args
        register_validation(:presence_of, slot, *args)
      end
      alias validate_presence_of validates_presence_of # nobody likes stupid typos
    end
    
    class Presence
      def initialize
        
      end
      
      def valid?(doc)
        
      end
    end
  end
end
