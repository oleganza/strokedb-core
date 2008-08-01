$LOAD_PATH.unshift( File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')) ).uniq!
require 'strokedb-core'
include StrokeDB::Core

SPEC_ROOT = File.expand_path(File.dirname(__FILE__))
TEMP_DIR = SPEC_ROOT + '/temp'
TEMP_STORAGES = TEMP_DIR + '/storages'

def setup_default_store(store=nil)
  # if store
  #   StrokeDB.stub!(:default_store).and_return(store)
  #   return store
  # end
  # @path = TEMP_STORAGES
  # FileUtils.rm_rf @path
  # 
  # @storage = if ENV['STORAGE'].to_s.downcase == 'file'
  #   StrokeDB::FileStorage.new(:path => @path + '/file_storage')
  # else
  #   StrokeDB::MemoryStorage.new
  # end
  # 
  # $store = StrokeDB::Store.new(:storage => @storage, :path => @path)
  # StrokeDB.stub!(:default_store).and_return($store)
  # StrokeDB.default_store
end

def stub_meta_in_store(store=nil)
  # store ||= StrokeDB.default_store
  # meta = store.find(NIL_UUID)
  # store.should_receive(:find).with(NIL_UUID).any_number_of_times.and_return(meta)
  # store.should_receive(:include?).with(NIL_UUID).any_number_of_times.and_return(true)
end


Spec::Runner.configure do |config|
  config.before(:all) do
    FileUtils.rm_rf TEMP_STORAGES
    FileUtils.mkdir_p TEMP_STORAGES
  end
  config.after(:all) do
    
  end
end
