require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe StrokeObjects::SlotHooks do
  
  before :each do
    @cls_with_hooks = Class.new(Hash) do
      extend StrokeObjects::SlotHooks
      slot_hook :name do
        
      end
    end
    
    @doc = @cls_with_hooks.new
  end
  
  it "should raise when unknown slot is accessed" do
    
  end
end
