require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "DefaultUuidHelpers" do
  before(:each) do
    @h = ClassFactory.make_instance([Repositories::AbstractHelpers, Repositories::DefaultUuidHelpers])
  end

  it { @h.generate_version(nil).should =~ UUID_RE }
  it { @h.generate_uuid(nil).should =~ UUID_RE }
  
end