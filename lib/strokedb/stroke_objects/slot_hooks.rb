module StrokeDB
  module StrokeObjects
    module SlotHooks
      include StrokeDB::Declarations
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
        
        #slot_hooks[slotname] ||= SlotHook.new
        #slot_hooks[slotname].extend(mod || Module.new(&blk))
      end
      
      def slot_hooks
        
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
          return hook.set(self, slotname, value) { super }
        end
      end # ObjectLayer
      
      # Default slot hook: no op.
      class SlotHook        
        def get(doc, slotname)
          yield # returns super
        end
        
        def set(doc, slotname, value)
          yield # returns super
        end
      end
    end
  end # StrokeObjects
end # StrokeDB
