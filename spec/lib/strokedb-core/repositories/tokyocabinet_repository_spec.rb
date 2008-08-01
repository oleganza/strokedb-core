require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "TokyoCabinetRepository with default setup" do
  before(:all) do
    @r = ClassFactory.make_instance([Repositories::DefaultUuidHelpers, 
                                     Repositories::HashHelper, 
                                     Repositories::MarshalHelper, 
                                     Repositories::TokyoCabinetRepository,
                                     Repositories::MetadataHashLayer])
    @r.open(:path => TEMP_STORAGES + "/tc.repo")
  end

  after(:all) do
    @r.close
  end 
  
  it "should create/read/updated/delete" do 
     d = @r.new_document 
     uuid = @r.post(d)
     uuid.should =~ UUID_RE
     @r.get(uuid).should == d
     
     
  end 
  
end
