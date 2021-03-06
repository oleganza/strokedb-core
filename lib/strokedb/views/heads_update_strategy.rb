module StrokeDB
  module Views
    module HeadsUpdateStrategy
      Cprevious_version = "previous_version".freeze
      
      # Updates index with a HEAD document version. 
      # Previous version's keys are removed.
      def update(repository, doc)
        previous_version = doc[Cprevious_version] or return update_pairs(map(doc), nil)
        prev = repository.get_version(previous_version) or return update_pairs(map(doc), nil)
        new_pairs = map(doc)
        old_pairs = map(prev)
        update_pairs(new_pairs, old_pairs)
      end
      
    end
  end
end
