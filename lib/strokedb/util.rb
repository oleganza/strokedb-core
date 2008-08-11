require 'time'
require 'strokedb/util/options_hash'
require 'strokedb/util/uuid'
require 'strokedb/util/class_factory'
require 'strokedb/util/require_one_of'
require 'strokedb/util/verify'

module StrokeDB
  include Util
    
  Util::require_one_of 'json', 'json_pure'
    
end
