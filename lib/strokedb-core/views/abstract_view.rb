module StrokeDB
  module Core
    module Views
      module AbstractView
        
        # Opens a view with the options.
        def open(options)
        end
        
        # Safely closes the view (closes file/connection or frees some resources).
        def close
        end
        
        # Finds a set of values stored in the view filtered with the options used.
        # 
        # * <tt>start_key</tt>: Prefix to start a search with.
        # * <tt>end_key</tt>: Prefix to end a search with.
        # nil is a valid value for keys.
        #
        # * <tt>limit</tt>: Maximum number of items to be returned. Default is <tt>nil</tt> (no limit).
        # * <tt>offset</tt>: Skip a given number of items starting with <tt>:start_key</tt>.
        #                     Default is <tt>0</tt> (skip nothing).
        # * <tt>reverse</tt>: Reverse the search direction. Search starts from the end of the 
        #                      index, goes to <tt>:start_key</tt> prefix and finishes before
        #                      the <tt>:end_key</tt> value. This works like 
        #                      an <tt>ORDER BY ... DESC</tt> SQL statement.
        #                      Default is <tt>false</tt> (i.e. direct search order).
        # * <tt>with_keys</tt>: Return a key-value pairs instead of just values.
        #                        Default is <tt>false</tt>.
        #
        # Returns a list of decoded values (see decode_value).
        # If with_keys is specified, returns a list of pairs [decoded_key, decoded_value]
        def find(start_key, end_key, limit, offset, reverse, with_keys)
        end
        
        # Updates index with a particular document version.
        # This method chooses which strategy to use: 
        # update_head or update_version. Former replaces info in the view,
        # 
        def update(doc)
        end
        
        # Removes previous key-value pairs, adds new ones.
        def update_head(uuid, version, doc, prev_version, prev_doc)
        end
        
        # Simply adds new key-value pairs for the particular version.
        def update_version(uuid, version, doc)
        end
        
        # Maps doc to a key-value view records.
        # Returns nil, empty list or a list of tuples.
        # tuple[0] stands for key, tuple[1] stands for value.
        # Keys and values are later encoded using encode_key(k) and 
        # encode_value(v) methods.
        def map(doc)
        end
        
        # Encoding stuff
        
        def encode_key(key)
        end

        def decode_key(encoded_key)
        end
              
        def encode_value(value)
        end

        def decode_value(evalue)
        end
      
      private
      
        # Handy helper for many cases.
        def map_with_encoding(doc)
          (map(doc) or []).map do |k, v|
            [encode_key(k), encode_value(v)]
          end
        end
      end
    end
  end
end
