$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/../lib")
require 'strokedb-core'
include StrokeDB::Core

dir = File.dirname(__FILE__)

MyDatabase = StrokeObjects::DatabaseMixin.new(:path => File.join(dir, "vkontakte_api.strokedb"))

class Audio
  include MyDatabase
end

class PhotoAlbum
  include MyDatabase
end

baby = Util.verify{ Audio.create(:artist => "Nouvelle Vague", :title => "Baby") }
summer = Audio.new(:artist => "Regina Spektor", :title => "Summer In The City")

Util.verify{ summer.save }


