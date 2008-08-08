module StrokeDB
  module Core
    module Plugins
      class Plugin
        # Default initializer tries to add ClassMethods and 
        # InstanceMethods to the user model.
        def initialize(database, options)
          p = self.class
          c = :ClassMethods and p.const_defined?(c) and options["extend_by_modules"] << p.const_get(c) 
          c = :InstanceMethods and p.const_defined?(c) and options["include_modules"] << p.const_get(c)
        end
      end
    end
  end
end
    