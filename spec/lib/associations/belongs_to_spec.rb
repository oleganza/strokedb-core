require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "Belongs to association" do
  
  before :each do
    @person_cls = Class.new(Hash) do
      include Associations
      belongs_to :account
    end
    @person = @person_cls.new
  end
  
  it "should provide reader methods" do
    @person.should respond_to(:account)
    @person.account.should == nil
  end
  
  it "should provide writer methods" do
    @person.should respond_to(:account=)
    @person.account = "Some account"
    @person.account.should == "Some account"
  end
  
end
