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
        end
        
        def find(start_key, end_key, limit, offset, reverse, with_keys)
          
          # faster implementation for normal order finds:
          if start_key and not reverse
            keys = @tc_bdb.fwmkeys(start_key, max)
          end
          
          cur = @tc_bdbcur # alias for faster access in tight loops (ivars are accessed by name)
          os = offset || 0
          results = []
          start_key_size = start_key ? start_key.size : 0
          end_key ||= C
          end_key_size   = end_key.size
          
          if cur.jump(start_key)
            # n.times{} looks cool, but works a bit slower.
            if reverse
              while (os -= 1) > -1; cur.prev; end
            else
              while (os -= 1) > -1; cur.next; end
            end
            
            # Return if offset jumped out of start_key prefix
            return results if offset and cur.key[0, start_key_size] != start_key
            
            # Now we have to move cursor in some direction, 
            # checking end_key complience and limit.
            i = 0
            if reverse
              while cur.prev
                key = cur.key
                key[0, end_key_size] < end_key and return results
                (i += 1) > limit and return results
                results.push(with_keys ? [key, cur.val] : cur.val)
              end
            else
              while cur.next
                key = cur.key
                key[0, end_key_size] > end_key and return results
                (i += 1) > limit and return results
                results.push(with_keys ? [key, cur.val] : cur.val)
              end
            end
          end
          results
        end
        
        # Updates index with a particular document version.
        # This method chooses which strategy to use: 
        # update_head or update_version. Former replaces info in the view,
        # 
        def update(repository, doc)
          # TODO!
        end
        
        # Removes previous key-value pairs, adds new ones.
        def update_head(uuid, version, doc, prev_version, prev_doc)
          # TODO!
        end
        
        # Simply adds new key-value pairs for the particular version.
        def update_version(uuid, version, doc)
          new_pairs = map(doc)
          # TODO: storage.insert(new_pairs)
        end
        
        # Vanishes the storage
        def vanish
          @tc_bdb.vanish or tc_raise("vanish")
        end
        
        # Syncs repository updates with the device
        def sync
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
