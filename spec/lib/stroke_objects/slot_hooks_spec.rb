require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe StrokeObjects::SlotHooks do
  
  before :each do
    
    @dumper_mod = dumper_mod = Module.new do
      def get(doc, slotname)
        v = super
        v ? Marshal.load(v) : v
      end
      def set(doc, slotname, value)
        super(doc, slotname, Marshal.dump(value))
      end
    end
    
    dumper = Module.new do
      extend StrokeObjects::SlotHooks
      slot_hook :name, dumper_mod
    end
    
    @model = Class.new(Hash) do
      include dumper
    end
    
    @doc = @model.new
  end
  
  it "should have composite hooks" do
    @model.slot_hooks[:name].meta_class.ancestors.should include(@dumper_mod)
  end
  
  it "should work" do
    @doc[:name].should == nil
    @doc[:name] = "test"
    @doc[:name].should == "test"
    
    @doc.values.should == [Marshal.dump("test")]
  end
end
