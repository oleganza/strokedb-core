require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "TokyoCabinetRepository with default setup" do
  before(:all) do
    @rc = ClassFactory.new(Repositories::AbstractRepository, 
                           Repositories::DefaultUuidHelpers, 
                           Repositories::HashHelper, 
                           Repositories::MarshalHelper, 
                           Repositories::TokyoCabinetRepository,
                           Repositories::MetadataHashLayer).new_class
    @oleg   = @rc.new
    @yrashk = @rc.new
    @oleg.open(:path => TEMP_STORAGES + "/oleg-branch.repo")
    @yrashk.open(:path => TEMP_STORAGES + "/yrashk-branch.repo")
  end

  after(:all) do
    @oleg.close
    @yrashk.close
  end 
  
  it "should work" do 
    d0 = @oleg.new_document
    uuid = d0["uuid"]
    uuid.should_not be_nil
    d0["type"] = "Audio"
    version1 = @oleg.put(d0.dup)
    
    @oleg.each_head.map{|u,ru,d| [u,ru]}.should == [[uuid, @oleg.uuid]]
    
    # Yurii fetches oleg's new document
    @yrashk.fetch(uuid, @oleg)
    
    # Now Yurii has oleg's document under oleg's repo uuid HEAD
    @yrashk.each_head.map{|u,ru,d| [u,ru]}.should == [[uuid, @oleg.uuid]]
    
  end
  
end
