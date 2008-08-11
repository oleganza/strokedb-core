require 'tokyocabinet'
module StrokeDB
  module Core
    module Views
      module TokyoCabinetView
        include TokyoCabinet
        attr_accessor :tc_path, :tc_bdb, :tc_bdbcur
        
        C = "".freeze
        
        # Opens a view with the options.
        def open(options)
          OptionsHash!(options)
          @tc_path = options.require("path")
          @tc_bdb = BDB::new
          mode = HDB::OWRITER | HDB::OCREAT
          @tc_bdb.open(@tc_path, mode) or tc_raise("open", @tc_path, mode)
          @tc_bdbcur = BDBCUR::new(@tc_bdb)
          nil
        end
        
        # Safely closes the view (closes file/connection or frees some resources).
        def close
          @tc_bdb.close or tc_raise("close")
          @tc_bdbcur = nil
        end
        
        MANY_0xFF = ("\xff"*8).freeze
        
        def find(start_key, end_key, limit, offset, reverse, with_keys)
          limit == 0 and return [] 
          
          # faster implementation for normal order finds:
          if start_key == end_key and start_key and not reverse
            keys = @tc_bdb.fwmkeys(start_key, limit)
            if keys.size > 0
              if end_key
                end_key_size = end_key.size
                keys = (limit ? keys[offset || 0, limit] : keys[offset || 0, keys.size]).select do |key|
                  key[0, end_key_size] <= end_key
                end
              end
              bdb = @tc_bdb
              if with_keys
                return keys.map{|k| [k, bdb.get(k)] }
              else
                return keys.map{|k| bdb.get(k) }
              end
            end
          end
          
          cur = @tc_bdbcur # alias for faster access in tight loops (ivars are accessed by name)
          os = offset || 0
          results = []
          start_key_size = start_key ? start_key.size : 0
          end_key_size   = end_key ? end_key.size : 0
          end_key ||= C
          
          if reverse
            # We should jump to a farthest matching key.
            # prefix: abc
            # we start with a prefix "abc\xff\xff\xff\xff\xff\xff\xff\xff",
            # case 0: abb, abdZZZ (jumped to abdZZZ)
            # case 1: abb1, abb2 (jump => false)
            # case 2: abcXXX, abcYYY, abdZZZ (jumped to abd, step back)
            # case 3: abcXXX, abcYYY (jump => false)
            # case 4: abcXXX, abcYYY, abc\xff\xff...suffix (move forward unless prefix == start_key)
            if start_key
              if cur.jump(start_key + MANY_0xFF)
                key = cur.key
                # matched prefix, step forward until not matched
                if key[0, start_key_size] == start_key
                  while cur.next and (tkey = cur.key)[0, start_key_size] == start_key
                    key = tkey
                  end
                  cur.jump(key) or raise "Unexpected BDBCUR#jump failure!"
                # prefix not matched, step back
                else
                  cur.prev or return [] # no previous record
                  cur.key[0, start_key_size] == start_key or return []
                end
              # not jumped to a suffix. 
              # This can happen when the last item has prefix or there's no item with such prefix.
              else
                (cur.last and cur.key[0, start_key_size] == start_key) or return []
              end
            else
              cur.last or return []
            end
            # n.times{} looks cool, but works a bit slower.
            while (os -= 1) > -1; cur.prev or return []; end
          else
            (start_key ? cur.jump(start_key) : cur.first) or return []
            while (os -= 1) > -1; cur.next or return []; end
          end

          # Return if offset jumped out of start_key prefix
          if offset and cur.key[0, start_key_size] != start_key
            return results
          end
          
          # Now we have to move cursor in some direction, 
          # checking end_key compliance and limit.
          i = 0
          if reverse
            while true
              key = cur.key
              key[0, end_key_size] < end_key and return results
              limit and (i += 1) > limit and return results
              results.push(with_keys ? [key, cur.val] : cur.val)
              cur.prev or return results
            end
          else
            while true
              key = cur.key
              key[0, end_key_size] > end_key and return results
              limit and (i += 1) > limit and return results
              results.push(with_keys ? [key, cur.val] : cur.val)
              cur.next or return results
            end
          end

          results
        end
                
        # Adds new_pairs and removes old_pairs. Both arguments can be nil.
        # Returns nil.
        def update_pairs(new_pairs = nil, old_pairs = nil)
          bdb = @tc_bdb
          old_pairs.each { |k, v| bdb.out(k)    } if old_pairs
          new_pairs.each { |k, v| bdb.put(k, v) } if new_pairs
          nil
        end
        
        # Vanishes the storage
        def vanish
          @tc_bdb.vanish or tc_raise("vanish")
        end
        
        # Syncs repository updates with the I/O device
        def iosync
          @tc_bdb.sync or tc_raise("sync")
        end
        
      private
      
        def tc_raise(meth, *args)
          ecode = @tc_bdb.ecode
          argsi = args.map{|a|a.inspect}.join(', ')
          raise(StorageError, "TokyoCabinet::BDB##{meth}(#{argsi}) error: %s\n" % @tc_bdb.errmsg(ecode))
        end
        
      end
    end
  end
end
