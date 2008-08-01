module StrokeDB
  module Core
  
    # Coverage threshold - bump this float anytime your changes increase the spec coverage
    # DO NOT LOWER THIS NUMBER. EVER.
    COVERAGE = 50

    # XML Schema time format
    # Time.now.xmlschema(6)
    #    #=> "2008-04-27T23:39:09.920288+04:00"
    # Time.xmlschema("2008-04-27T23:39:09.920288+04:00")
    #    #=> Sun Apr 27 19:39:09 UTC 2008
    XMLSCHEMA_TIME_RE = /\A\s*(-?\d+)-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)(\.\d*)?(Z|[+-]\d\d:\d\d)?\s*\z/i
  
    # STROKEDB NSURL
    STROKEDB_NSURL = "http://strokedb.com/"

    if ENV['DEBUG'] || $DEBUG
      def DEBUG
        yield
      end
    else
      def DEBUG
      end
    end

    OPTIMIZATIONS = []
    OPTIMIZATIONS << :C    unless RUBY_PLATFORM =~ /java/
    OPTIMIZATIONS << :Java if     RUBY_PLATFORM =~ /java/

  end
end
