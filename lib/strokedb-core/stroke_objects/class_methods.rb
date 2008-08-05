module StrokeDB
  module Core
    module StrokeObjects
      # DatabaseMixin mixes this module into the class, it is included to.
      module ClassMethods
        attr_accessor :stroke_mixin
        
        def find
          
        end
        
        def new(options = {}, *args, &blk)
          obj = super(options, *args, &blk)
          obj.strokedb_mixin = strokedb_mixin
          obj.strokedb_doc = strokedb_mixin.repo.new_document
          obj
        end
        
        def create(*args, &blk)
          obj = new(*args, &blk)
          obj.save
          obj
        end
        
      end
    end
  end
end
