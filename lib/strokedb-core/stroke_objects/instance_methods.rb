module StrokeDB
  module Core
    module StrokeObjects
      # This module is mixed in DatabaseMixin, thus it is mixed into every model class.
      module InstanceMethods
        attr_accessor :strokedb_doc, :strokedb_mixin
        
        def initialize(options, &blk)
          @options = OptionsHash!(options.dup)
          yield(self) if block_given?
        end
        
        Cuuid = "uuid"
        def save
          repo = @strokedb_mixin.repo
          sdoc = @strokedb_doc
          if sdoc[Cuuid]
            version = repo.put(sdoc[Cuuid], sdoc)
          else
            uuid, version = repo.post(sdoc)
          end
          true
        end

        # This method catches slot access calls. 
        # Slots are created on the fly.
        Ceq = "="
        R_0_minus1 = 0..-1
        def method_missing(meth, *args, &blk)
          meth = meth.to_s
          is_setter = (meth[-1,1] == Ceq && meth = meth[R_0_minus1])
          if is_setter
            self[meth] = args.first
          else
            return super unless args.empty?
            self[meth]
          end
        end
        
        def []=(slotname, value)
          
        end
        
        def [](slotname)
          
        end
        
        def marshal_dump
          ""
        end
        
      end
    end
  end
end
