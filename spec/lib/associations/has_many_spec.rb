require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "has_many :as" do
  
  before(:each) do
    @person_mod = Module.new do
      extend Associations::HasMany
      has_many :owned_accounts, :as => :owner, :kind_of => []
    end
  end
  
  it "should description" do
    
  end
  
end
