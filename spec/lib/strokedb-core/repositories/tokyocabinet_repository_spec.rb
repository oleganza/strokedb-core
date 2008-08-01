require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "TokyoCabinetRepository" do
  include Repositories
  before(:each) do
    @r = ClassFactory.make_instance([DefaultUuidHelpers, HashHelper, MarshalHelper, TokyoCabinetRepository])
    @r.open
  end

  after(:each) do
    @r.close
  end 
  
  it "should be covered by specs" do
    
  end

end
