$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/../lib")
require 'strokedb-core'
include StrokeDB::Core

puts StrokeDB::Core::VERSION

ApplicationDatabase = StrokeObjects::DatabaseMixin.new(:path => "vkontakte_api.strokedb")

class Audio
  include ApplicationDatabase
  
  
end

class Album
  include ApplicationDatabase
  
end

