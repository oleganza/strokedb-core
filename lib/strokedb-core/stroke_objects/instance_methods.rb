module StrokeDB
  module Core
    module StrokeObjects
      # This module is mixed in Database mixin, thus it is mixed into every model class.
      module InstanceMethods
        Cuuid = "uuid"
        Cversion = "version"
        
        attr_accessor :strokedb_database
        attr_accessor :strokedb_slots
        
        # Initialized with a set of slots
        def initialize(db, slots, &blk)
          @strokedb_database = db
          @strokedb_slots = OptionsHash!(slots.dup)
          yield(self) if block_given?
        end

        def save
          repo = @strokedb_database.repo
          repo.put(@strokedb_slots)
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
          @strokedb_slots[slotname.to_s] = value
        end
        
        def [](slotname)
          @strokedb_slots[slotname.to_s]
        end
        
        def marshal_dump
          @strokedb_slots
        end
        
        # TODO: think how the db connection should be restored after the load
        def marshal_load(slots)
          initialize(nil, slots)
        end
        
        def ==(other)
          slots = @strokedb_slots
          slots[Cuuid] == other.uuid && slots[Cversion] == other.version
        end
      end
    end
  end
end
