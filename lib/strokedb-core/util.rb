require 'time'
require 'util/options_hash'
require 'util/uuid'
require 'util/class_factory'
require 'util/require_one_of'
require 'util/verify'

module StrokeDB
  module Core
    include Util
    
    Util::require_one_of 'json', 'json_pure'
    
  end
end