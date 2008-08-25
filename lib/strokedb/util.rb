require 'time'
require 'strokedb/util/absolutely_all_ancestors'
require 'strokedb/util/options_hash'
require 'strokedb/util/uuid'
require 'strokedb/util/class_factory'
require 'strokedb/util/require_one_of'
require 'strokedb/util/verify'
require 'strokedb/util/pluggable_module'
require 'strokedb/util/declarations'
require 'strokedb/util/lazy_mapping_array'

module StrokeDB
  include Util
    
  Util::require_one_of 'json', 'json_pure'
    
end
