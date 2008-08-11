module StrokeDB
  module StrokeObjects
    # Database mixes this module into the class it is included to.
    #
    # MyModel.new(attributes = {})  #=> initializes new document
    # doc.save                      # saves the document
    # doc.reference = another_doc   # stores the reference
    #
    module ClassMethods
      attr_accessor :strokedb_database
      
      # Called when database is configured.
      def strokedb_configured(database)
        @strokedb_database = database
      end
      
      def find_by_uuid(uuid, &blk)
        db = @strokedb_database
        doc = db.repo.get(uuid)
        obj = nil
        if doc
          obj = allocate
          obj.send(:initialize, db, doc, &blk)
        end
        obj
      end
      
      def find(*args, &blk)
        first_arg = args.shift
        return find_by_uuid(first_arg, &blk) if String === first_arg && args.empty?
        return find_by_query(first_arg, *args, &blk)
      end
      alias :[] :find
      
      
      def new(slots = {}, *args, &blk)
        slots = OptionsHash!(slots.dup)
        db = @strokedb_database
        obj = super(db, slots.merge(db.repo.new_document), *args, &blk)
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
