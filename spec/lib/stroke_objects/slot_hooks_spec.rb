require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe StrokeObjects::SlotHooks do
  
  before :each do
    @cls_with_hooks = Class.new(Hash) do
      include StrokeObjects::SlotHooks
    end
    
    
    
    @doc = @cls.new
  end
  
  it "should raise when unknown slot is accessed" do
    
  end
