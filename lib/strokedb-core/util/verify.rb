module StrokeDB
  module Core
    module Util
      def self.verify(*args, &blk)
        m = self
        (@__verify_proxy ||= Class.new{include m; def initialize(*args, &blk); @__verify_skip_level = 2; super; end}.new).verify(*args, &blk)
      end
      def verify(*args, &blk)
        if block_given? # test for exception
          begin
            r = yield(*args)
          rescue Exception => e
            raise VerifyFailed.new(e, @__verify_skip_level), "Verification failed!"
          else
            r or raise VerifyFailed.new(nil, @__verify_skip_level), "Verification failed!"
          end
        else
          if args.size == 1
            args.first or raise VerifyFailed.new(nil, @__verify_skip_level), "Verification failed!"
          else
            args.each_with_index do |a, i|
              a or raise VerifyFailed.new(nil, @__verify_skip_level), "Verification failed at the #{i+1} argument!"
            end
            true
          end
        end
      end
      class VerifyFailed < Exception
        def initialize(exception = nil, level = 1)
          @exception = exception
          @level = level
        end
        def message
          return super unless @exception
          super + "\n" + @exception.message + "\n"
        end
        def backtrace
          return super unless @exception
          @exception.backtrace[(@level || 1)..-1]
        end
      end
    end
  end
end
      