module StrokeDB
  module Views
    # Default codec just passes value by.
    module DefaultValueCodec

      def encode_value(v)
        v
      end
      
      def decode_value(ev)
        ev
      end

    end
  end
end
