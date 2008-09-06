module StrokeDB
  module StrokeObjects
    module SlotHooks
      include Declarations
      # Sets inheritable get/set hooks on a slot.
      #
      # Example:
      #
      # class Person < Hash
      #   extend SlotHooks
      #
      #   slot_hook :name do
      #     def get(doc, slotname)
      #       puts "Accessing slot #{slotname}"
      #       super
      #     end
      #     def set(doc, slotname, value)
      #       puts "Writing to slot #{slotname}"
      #       super
      #     end
      #   end
      # end
      #
      def slot_hook(slotname, mod = nil, &blk)
        local_declarations(:slot_hooks, Hash.new) do |hooks|
          hooks[slotname] ||= []
          hooks[slotname] << (mod || Module.new(&blk))
          hooks
        end
      end
      
      def slot_hooks(hook_class = DefaultSlotHook)
        inherited_declarations(:slot_hooks) do |inherited_data|
          # Build hooks for all slots with inheritance in mind.
          inherited_data.inject(Hash.new) do |all_hooks, local_hooks|
            local_hooks.inject(all_hooks) do |hooks, (slotname, modules)|
              hook = (hooks[slotname] ||= hook_class.new)
              modules.each {|m| hook.extend(m) }
              hooks
            end
          end
        end
      end
      
      # Include ObjectLayer where extended.
      def self.extended(mod)
        super
        mod.send(:include, ObjectLayer)
      end
      
      module ObjectLayer
        def slot_hooks
          @slot_hooks ||= self.class.slot_hooks
        end
      
        def [](slotname)
          return super unless hook = slot_hooks[slotname]
          return hook.get(self, slotname) { super }
        end
      
        def []=(slotname, value)
          return super unless hook = slot_hooks[slotname]
          return hook.set(self, slotname, value) { |k,v| super(k,v) }
        end
      end # ObjectLayer
      
      # Default slot hook: no op.
      class DefaultSlotHook        
        def get(doc, slotname)
          yield # returns super
        end
        
        def set(doc, slotname, value)
          yield(slotname, value) # returns super
        end
      end # DefaultSlotHook
      
    end # SlotHooks
  end # StrokeObjects
end # StrokeDB
