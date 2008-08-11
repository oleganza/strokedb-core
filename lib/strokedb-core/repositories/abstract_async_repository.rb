module StrokeDB
  module Repositories
    # TODO: finish this!
    module AbstractAsyncRepository
    
      # When database is opened
      def on_open
      end
    
      # When database is closed
      def on_close
      end
    
      # Receives a document by version
      def on_get_version(doc)
      end

      # Recieves a document
      def on_get(document)
      end
    
      # Receives new document's uuid.
      def on_post(uuid)
      end
      
      # TODO!
      # ...

    end
  end # Repositories
end # StrokeDB
