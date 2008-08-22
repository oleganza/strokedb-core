module StrokeDB
  module StrokeObjects
    # Included in a StrokeDB object.
    # Relies on #has_slot? method.
    module LazyAccessors
      # This method catches slot access calls (obj.slot, obj.slot=). 
      # Slot accessors are created on the fly.
      Ceq = "="
      R_0_minus1 = (0..-2)
      def method_missing(meth, value = nil, *args, &blk)
        slotname = meth.to_s
        is_setter = (slotname[-1,1] == Ceq && slotname = slotname[R_0_minus1])
        if has_slot?(slotname)
          meta_class = (class <<self;self;end)
          if is_setter
            meta_class.send(:define_method, meth) do |v|
              self[slotname] = v
            end
            send(meth, value)
          else
            meta_class.send(:define_method, meth) do
              self[slotname]
            end
            send(meth)
          end
        else
          super
        end # if has_slot?
      end # def method_missing
      
    end # LazyAccessors
  end # StrokeObjects
end # StrokeDB
