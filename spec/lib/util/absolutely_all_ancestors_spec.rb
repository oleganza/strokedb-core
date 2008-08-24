require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
describe "Module#absolutely_all_ancestors" do
  before(:all) do
    module M0; end
    module A1; end
    module A2; end

    module B1
    end

    module B2
      include A2
    end

    class C
      include B1
      include B2
    end

    module B1
      include A1
    end
    
    module A1 
      include M0
    end
  end
  
  it "should == ancestors for modules, included before definition of C" do
    [A1, A2, B2].each do |m| 
      m.ancestors.should == m.absolutely_all_ancestors
    end
  end

  it "should give A1 and M0 for C" do
    (C.absolutely_all_ancestors - C.ancestors).should == [A1, M0]
  end

end
