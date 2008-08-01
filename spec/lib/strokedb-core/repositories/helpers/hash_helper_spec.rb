require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "HashHelper" do
  before(:each) do
    @h = ClassFactory.make_instance([Repositories::AbstractHelpers, Repositories::HashHelper])
  end

  it { @h.new_empty_document.should == { } }
  it { @h.new_deleted_document.should == { "deleted" => true } }
  
end
