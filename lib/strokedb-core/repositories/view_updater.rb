require 'tokyocabinet'

module StrokeDB
  module Core
    module Repositories
      # Wraps around store() method invoking views updates.
      #
      module ViewUpdater
        attr_accessor :vu_views
        
        def open(options)
          OptionsHash! options
          @vu_views = options["views"] || []
          super(options)
        end
        
        def store(version, uuid, doc)
          update_views(version, uuid, doc)
          super(version, uuid, doc)
        end
        
        # This method can be overriden on the higher API levels.
        def update_views(version, uuid, doc)
          @vu_views.each do |view|
            view.update(self, doc)
          end
          nil
        end
      end
    end # Repositories
  end # Core
end # StrokeDB
