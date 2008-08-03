module StrokeDB
  module Core
    module Views
      # Module relies on the following methods:
      #
      #  * encode_key(k)
      #  * decode_key(ek)
      #  * encode_value(v)
      #  * decode_key(ev)
      #
      module EncodingLayer

        def find(start_key, end_key, limit, offset, reverse, with_keys)
          rs = super(start_key and encode_key(start_key), 
                     end_key and encode_key(end_key), 
                     limit, offset, reverse, with_keys)
          if with_keys
            rs.map do |kv|
              kv[0] = decode_key(kv[0])
              kv[1] = decode_value(kv[1])
              kv
            end
          else
            rs.map do |v|
              decode_value(v)
            end
          end
        end
        
        def map(doc)
          (super(doc) or []).map do |k, v|
            [encode_key(k), encode_value(v)]
          end
        end
              
      end
    end
  end
end
