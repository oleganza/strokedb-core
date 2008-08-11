require 'tokyocabinet'

module StrokeDB
  module Repositories
    module Iterators
      class Iterator
        include Enumerable
        attr_accessor :repo
        def initialize(repo)
          @repo = repo
        end
      end
      class UuidsIterator < Iterator
        def each(*args, &blk)
          @repo.each_head(*args, &blk)
        end
      end
      class VersionsIterator < Iterator
        def each(*args, &blk)
          @repo.each_version(*args, &blk)
        end
      end
    end
  end # Repositories
end # StrokeDB
