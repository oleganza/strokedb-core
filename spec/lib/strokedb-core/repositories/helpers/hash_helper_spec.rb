require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "HashHelper" do
  before(:each) do
    @h = ClassFactory.new(Repositories::AbstractHelpers, Repositories::HashHelper).new.new
  end

  it { @h.new_document.should == { } }
  it { @h.new_deleted_document.should == { "deleted" => true } }
  
end
