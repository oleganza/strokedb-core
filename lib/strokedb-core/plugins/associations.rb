module StrokeDB
  module Plugins
    class Associations < Plugin
      
      module ClassMethods
        attr_accessor :associations
        def has_many(*args)
          @associations << [:has_many, args]
        end
        
        def strokedb_configured(*args)
          super
          @associations = []
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
