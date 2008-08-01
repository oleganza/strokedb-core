require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "TokyoCabinetRepository" do
  before(:each) do
    @r = ClassFactory.make_instance([Repositories::DefaultUuidHelpers, 
                                     Repositories::HashHelper, 
                                     Repositories::MarshalHelper, 
                                     Repositories::TokyoCabinetRepository])
    @r.open(:path => TEMP_STORAGES + "/tc.repo")
  end

  after(:each) do
    @r.close
  end 
  
  it "should be covered by specs" do
    pending
  end

end
