require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe StrokeObjects::LazyAccessors do
  
  before :each do
    @cls = Class.new(Hash) do
      include StrokeObjects::LazyAccessors
      include Util::OptionsHash # for strigification
      def has_slot?(slotname)
        has_key?(slotname.to_s)
      end
    end
    @doc = @cls.new
  end
  
  it "should raise when unknown slot is accessed" do
    lambda { @doc.unknown     }.should raise_error(NoMethodError)
    lambda { @doc.unknown     }.should raise_error(NoMethodError)
    lambda { @doc.unknown = 1 }.should raise_error(NoMethodError)
    lambda { @doc.unknown = 1 }.should raise_error(NoMethodError)
    lambda { @doc.unknown     }.should raise_error(NoMethodError)
    lambda { @doc.unknown = 1 }.should raise_error(NoMethodError)
  end
  
  it "should provide access to a slot with method call" do
    @doc["key"] = "value"
    @doc["key"].should == "value"
    @doc.key.should == "value"
    @doc.key = "value2"
    @doc.key.should == "value2"
    @doc["key"].should == "value2"
    @doc["key"] = "value3"
    @doc["key"].should == "value3"
    @doc.key.should == "value3"
  end
  
  it "should create missing methods on first call" do
    @doc["key"] = "value"
    @doc.should_not respond_to(:key)
    @doc.should_not respond_to(:key=)
    @doc.key.should == "value"
    @doc.should     respond_to(:key)
    @doc.should_not respond_to(:key=)
    @doc.key = "value2"
    @doc.should     respond_to(:key)
    @doc.should     respond_to(:key=)
  end
end
