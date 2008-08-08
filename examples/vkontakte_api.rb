$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/../lib")
require 'strokedb-core'
include StrokeDB::Core

dir = File.dirname(__FILE__)

MyDatabase = StrokeObjects::Database.new(
                :path    => File.join(dir, ".vkontakte_api.strokedb"),
                :plugins => [ Plugins::Validations, Plugins::Associations, Plugins::Callbacks ]
                )

module MyValidations
#  validate_something
end

class Base
#  validate
end

class User
  include MyDatabase # should be included into classes only!
  validate_presence_of :name
  before_save :some_method
  has_many :photo_albums
  
  def some_method
    
  end
end

class Audio
  include MyDatabase # should be included into classes only!
end

class PhotoAlbum
  include MyDatabase
end

include Util

User.create :name => "Oleg"

baby = verify{ Audio.create(:artist => "Nouvelle Vague", :title => "Baby") }
summer = Audio.new(:artist => "Regina Spektor", :title => "Summer In The City")

verify{ summer.save }

verify{ baby.uuid =~ UUID_RE }
verify{ baby.version }
verify{ baby.previous_version == nil }
verify{ baby.artist == "Nouvelle Vague" }
verify{ baby.title == "Baby" }
verify{ baby[:title] == "Baby" }
verify{ baby["title"] == "Baby" }

baby = verify{ Audio.find(baby.uuid) }

# Find by UUID:
verify { Audio.find(baby.uuid) == baby }
# identity map in action:
verify { Audio.find(baby.uuid).object_id == baby.object_id }

# Find by query:
verify { Audio.find(:uuid => baby.uuid) == baby }


