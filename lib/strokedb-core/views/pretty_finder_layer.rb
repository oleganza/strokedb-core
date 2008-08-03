module StrokeDB
  module Core
    module Views
      module PrettyFinderLayer

        DEFAULT_FIND_OPTIONS = {
          :start_key  => nil,   # start search with a given prefix
          :end_key    => nil,   # stop search with a given prefix
          :limit      => nil,   # retrieve at most <N> entries
          :offset     => 0,     # skip a given number of entries
          :reverse    => false, # reverse search direction and meaning of start_key & end_key 
          :key        => nil,   # prefix search (start_key == end_key)
          :with_keys  => false  # returns [key, value] pairs instead of just values
        }
        
        # These constants save us many GC cycles. 
        # Ruby creates a brand new object every time it executes String literal :-(
        C           = ''.freeze
        Ckey        = 'key'.freeze
        Cstart_key  = 'start_key'.freeze
        Cend_key    = 'end_key'.freeze
        Climit      = 'limit'.freeze
        Coffset     = 'offset'.freeze
        Creverse    = 'reverse'.freeze
        Cwith_keys  = 'with_keys'.freeze
        
        # Finds a set of values stored in the view filtered with the options used.
        # 
        # * <tt>:start_key</tt>: Prefix to start a search with.
        # * <tt>:end_key</tt>: Prefix to end a search with.
        # * <tt>:key</tt>: Setting :key option is equivalent to set both <tt>:start_key</tt>
        #                  and <tt>:end_key</tt> to the same value.
        # By default, both keys are <tt>nil</tt> (and these are valid values). 
        #
        # * <tt>:limit</tt>: Maximum number of items to be returned. Default is <tt>nil</tt> (no limit).
        # * <tt>:offset</tt>: Skip a given number of items starting with <tt>:start_key</tt>.
        #                     Default is <tt>0</tt> (skip nothing).
        # * <tt>:reverse</tt>: Reverse the search direction. Search starts from the end of the 
        #                      index, goes to <tt>:start_key</tt> prefix and finishes before
        #                      the <tt>:end_key</tt> value. This works like 
        #                      an <tt>ORDER BY ... DESC</tt> SQL statement.
        #                      Default is <tt>false</tt> (i.e. direct search order).
        # * <tt>:with_keys</tt>: Return a key-value pairs instead of just values.
        #                        Default is <tt>false</tt>.
        #
        # Examples:
        #   view.find                             # returns all the items in a view
        #   view.find(:limit => 1)                # returns the first document in a view
        #   view.find(:offset => 10, :limit => 1) # returns 11-th document in a view (Note: [doc] instead of doc)
        #   view.find(doc)                        # returns all items with a doc.uuid prefix 
        #   
        #   # returns the latest 10 comments for a given document
        #   # (assuming the key defined as [comment.document, comment.created_at])
        #   has_many_comments.find(doc, :limit => 10, :reverse => true)  
        #
        #   comments.find([doc, 2.days.ago..Time.now]) # returns doc's comments within a time interval
        #   # example above is equivalent to:
        #   a) find(:key => [doc, 2.days.ago..Time.now])
        #   b) find(:start_key => [doc, 2.days.ago], :end_key => [doc, Time.now])
        #
        # Effectively, first argument sets :key option, which in turn
        # specifies :start_key and :end_key.
        # Low-level search is performed using :start_key and :end_key only.
        #
        def find(key = nil, options = {}, *lower_args, &lower_blk)
          # See simple_find as an alias to lower-level find()
          return super(*lower_args, &lower_blk) if key == :__no_pretty_finder__
          
          if !key || key.is_a?(Hash)
            options = (key || {})
            OptionsHash!(options, DEFAULT_FIND_OPTIONS)
          else
            options = (options || {})
            OptionsHash!(options, DEFAULT_FIND_OPTIONS)
            options[Ckey] ||= key
          end

          if key = options[Ckey]
            startk, endk = pf_traverse_key(key)
            options[Cstart_key] ||= startk != C && startk || nil
            options[Cend_key]   ||= endk != C   && endk   || nil
          end

          start_key  = options[Cstart_key]
          end_key    = options[Cend_key]
          limit      = options[Climit]
          offset     = options[Coffset]
          reverse    = options[Creverse]
          with_keys  = options[Cwith_keys]

          super(start_key, end_key, limit, offset, reverse, with_keys)
        end
        
        # Alias to lower level API method
        def simple_find(*args, &blk)
          find(:__no_pretty_finder__, nil, *args, &blk)
        end
        
        # Traverses a user-friendly key in a #find method.
        # Example:
        #   find(["prefix", 10..42, "sfx", "a".."Z" ])
        #   # => start_key == ["prefix", 10, "sfx", "a"]
        #   # => end_key   == ["prefix", 42, "sfx", "Z"]
        #
        def pf_traverse_key(key, sk = [], ek = [], s_inf = nil, e_inf = nil) 
          case key
          when Range
            a = key.begin
            b = key.end
            [
              s_inf || a.infinite? ? sk : (sk << a),  # FIXME: refactor this core extension!
              e_inf || b.infinite? ? ek : (ek << b),  # FIXME: refactor this core extension!
            ] 
          when Array
            key.inject([sk, ek]) do |se, i| 
              pf_traverse_key(i, se[0], se[1], s_inf, e_inf)
            end
          else
            [s_inf ? sk : (sk << key), e_inf ? ek : (ek << key)]
          end
        end
      end
    end
  end
end
