require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "TokyoCabinetRepository with default setup" do
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
  
  it { @r }

end
