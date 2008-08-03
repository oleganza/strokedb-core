require 'tokyocabinet'
module StrokeDB
  module Core
    module Views
      module OnMemoryView
        attr_accessor :ram_list
        
        # Opens a view with the options.
        def open(options)
          @ram_list = Array.new
          nil
        end
        
        # Safely closes the view (closes file/connection or frees some resources).
        def close
          @ram_list = nil
        end
        
        def find(start_key, end_key, limit, offset, reverse, with_keys)
          # 
          # # faster implementation for normal order finds:
          # if start_key and not reverse
          #   keys = @tc_bdb.fwmkeys(start_key, max)
          #   if keys.size > 0
          #     end_key_size = end_key.size
          #     keys = keys[offset || 0, limit || Float::MAX].select do |key|
          #       key[0, end_key_size] <= end_key
          #     end
          #     bdb = @tc_bdb
          #     if with_keys
          #       return keys.map{|k| [k, bdb.get(k)] }
          #     else
          #       return keys.map{|k| bdb.get(k) }
          #     end
          #   end
          # end
          # 
          # cur = @tc_bdbcur # alias for faster access in tight loops (ivars are accessed by name)
          # os = offset || 0
          # results = []
          # start_key_size = start_key ? start_key.size : 0
          # end_key ||= C
          # end_key_size   = end_key.size
          # 
          # if cur.jump(start_key)
          #   # n.times{} looks cool, but works a bit slower.
          #   if reverse
          #     while (os -= 1) > -1; cur.prev; end
          #   else
          #     while (os -= 1) > -1; cur.next; end
          #   end
          #   
          #   # Return if offset jumped out of start_key prefix
          #   return results if offset and cur.key[0, start_key_size] != start_key
          #   
          #   # Now we have to move cursor in some direction, 
          #   # checking end_key compliance and limit.
          #   i = 0
          #   if reverse
          #     while cur.prev
          #       key = cur.key
          #       key[0, end_key_size] < end_key and return results
          #       (i += 1) > limit and return results
          #       results.push(with_keys ? [key, cur.val] : cur.val)
          #     end
          #   else
          #     while cur.next
          #       key = cur.key
          #       key[0, end_key_size] > end_key and return results
          #       (i += 1) > limit and return results
          #       results.push(with_keys ? [key, cur.val] : cur.val)
          #     end
          #   end
          # end
          # results
        end
                
        # Adds new_pairs and removes old_pairs. Both arguments can be nil.
        # Returns nil.
        def update_pairs(new_pairs = nil, old_pairs = nil)
          # bdb = @tc_bdb
          # old_pairs.each { |k, v| bdb.out(k)    } if old_pairs
          # new_pairs.each { |k, v| bdb.put(k, v) } if new_pairs
          nil
        end
        
        # Vanishes the storage
        def vanish
          @ram_list.clear
          nil
        end
        
        # Syncs repository updates with the device
        def sync
          nil
        end
        
      private
      
        
        
      end
    end
  end
end
