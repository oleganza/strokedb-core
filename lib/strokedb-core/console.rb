require 'irb'

module StrokeDB
  module Console
    def self.included(klass)
      klass.module_eval do
        
        def setup
          # TODO: setup default DB 
        end
        
        def help!
          puts ("
            n/a yet
            ".unindent!)
        end
        
      end
      klass.send(:include, StrokeDB)
      klass.send(:setup)
      
      puts "StrokeDB #{::StrokeDB::VERSION} (help! for more info)"
    end # self.included
  end # Console
end # StrokeDB
