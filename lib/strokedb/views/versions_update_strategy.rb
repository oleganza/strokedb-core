module StrokeDB
  module Views
    module VersionsUpdateStrategy
      
      # Add pairs of new document version to index.
      def update(repository, doc)
        update_pairs(map(doc), nil)
      end
              
    end
  end
end
