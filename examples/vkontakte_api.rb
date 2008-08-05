$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/../lib")
require 'strokedb-core'
include StrokeDB::Core

puts StrokeDB::Core::VERSION

MyDatabase = StrokeObjects::DatabaseMixin.new(:path => "vkontakte_api.strokedb")

class Audio
  include MyDatabase
  
  
end

class Album
  include MyDatabase
  
end

