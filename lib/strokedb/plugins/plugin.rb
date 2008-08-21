module StrokeDB
  module Plugins
    module Plugin
      def self.included(plugin)
        plugin.extend(ClassMethods)
      end
      
      # Default initializer tries to add ClassMethods and InstanceMethods to the user model.
      module ClassMethods
        def configure(database, options)
          m = self
          p(m)
          c = :ClassMethods and m.const_defined?(c) and options["extend_by_modules"] << m.const_get(c) 
          c = :InstanceMethods and m.const_defined?(c) and options["include_modules"] << m.const_get(c)
        end
        
        # called when a particular plugin in included somewhere
        def included(mod)
          m = self
          #puts "#{self} included into #{mod} #{[m.const_defined?(:ClassMethods), m.const_defined?(:InstanceMethods)]}"
          c = :ClassMethods and m.const_defined?(c) and mod.extend(m.const_get(c))
          c = :InstanceMethods and m.const_defined?(c) and mod.send(:include, m.const_get(c))
        end
      end
    end
  end
end
    