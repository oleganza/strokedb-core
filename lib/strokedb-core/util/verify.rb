module StrokeDB
  module Util
    def verify(*args, &blk)
      if block_given? # test for exception
        begin
          r = yield(*args)
        rescue Exception => e
          raise VerifyFailed.new(e), "Verification failed!"
        else
          r or raise VerifyFailed.new(nil), "Verification failed!"
        end
      else
        if args.size == 1
          args.first or raise VerifyFailed.new(nil), "Verification failed!"
        else
          args.each_with_index do |a, i|
            a or raise VerifyFailed.new(nil), "Verification failed at the #{i+1} argument!"
          end
          true
        end
      end
    end
    
    class <<self; self; end.send(:define_method, :verify, instance_method(:verify))

    class VerifyFailed < Exception
      def initialize(exception = nil)
        @exception = exception
      end
      def message
        return super unless @exception
        super + "\n" + @exception.message + "\n"
      end
      def backtrace
        return super unless @exception
        @exception.backtrace
      end
    end
  end
end
      