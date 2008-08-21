module StrokeDB
  module Util
    # Usage: OptionsHash!(options); options.require("required_option")
    # 1. Lets access string and symbol keys interchangebly.
    # 2. Lets specify required keys.
    def OptionsHash(hash, defaults = nil)
      OptionsHash!(hash.dup, defaults)
    end
    
    def OptionsHash!(hash, defaults = nil)
      unless hash.is_a?(OptionsHash) # not OptionsHash yet
        hash.keys.each {|k| hash[k.to_s] = hash.delete(k) } # stringify keys
        hash.extend(OptionsHash)
      end
      hash.replace(OptionsHash!(defaults).merge(hash)) if defaults
      hash
    end
    
    module OptionsHash
      # Raises exception if value is nil.
      def require(k, msg = nil)
        v = self[k]
        if v.nil? 
          msg ||= "Option #{k} is required!"
          raise RequiredOptionMissing, msg
        else
          v
        end
      end
      def delete_required(k, msg = nil)
        r = require(k, msg)
        delete(k)
        r
      end        
      def [](k)
        super(k.to_s)
      end
      def []=(k, v)
        super(k.to_s, v)
      end
      class RequiredOptionMissing < Exception; end
    end
  end
end
  