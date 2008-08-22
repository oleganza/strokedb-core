module StrokeDB
  module StrokeObjects
    module SlotHooks
      def self.included(mod)
        mod.extend(ClassMethods)
      end
      
      def initialize(*args)
        super
        @hooks ||= {}
      end
      
      def [](slotname)
        if hook = @get_hooks[slotname]
          return hook.get { super }
        end
        super
      end
      
      def []=(slotname, value)
        if hook = @set_hooks[slotname]
          return hook.set(value) { super }
        end
        super
      end
      
      module ClassMethods
        # def set_hook
        # end
      end
    end
  end
end
