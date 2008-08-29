module StrokeDB
  module NSURL
    include StrokeDB::Declarations
    
    NO_NSURL = Object.new.freeze
    
    # Returns the most local NSURL or sets
    # nsulr in the current scope.
    def nsurl(nsurl = NO_NSURL)
      return self.nsurl=(nsurl) if nsurl != NO_NSURL
      inherited_declarations(:nsurl) do |all_nsurls|
        all_nsurls.first
      end
    end
    
    def nsurl=(nsurl)
      nsurl ? local_declarations_set(:nsurl, nsurl) : local_declarations_remove(:nsurl)
    end
    
    module Ours
      extend NSURL
      nsurl StrokeDB::STROKEDB_NSURL
    end
    
    module Theirs
      extend NSURL
      nsurl StrokeDB::DEFAULT_NSURL
    end
    Others = Theirs # useful const alias
  end
end
