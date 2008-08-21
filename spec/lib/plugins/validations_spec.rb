require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "Validations" do
  
  class ::Module
    def setup_validations!
      include Plugins::Validations
      
      #include Plugins::Validations::InstanceMethods
      #extend Plugins::Validations::ClassMethods
    end
  end
  
  module ContactsValidations
    setup_validations!
    validate_presence_of :phone
    validate_presence_of :email
  end
  
  module MoreValidations
    setup_validations!
    include ContactsValidations
    validate_presence_of :more
  end
  
  class Person
    setup_validations!
    include ContactsValidations
    validate_presence_of :name
  end

  before :each do
  end
  
  it "should be inheritable when defined in a module" do
    ContactsValidations.validations.should == [
      [:presence_of, :phone],
      [:presence_of, :email]
    ]
    Person.validations.should == [
      [:presence_of, :name],
      [:presence_of, :phone],
      [:presence_of, :email]
    ]
    MoreValidations.validations.should == [
      [:presence_of, :more],
      [:presence_of, :phone],
      [:presence_of, :email]
    ]
    Person.send(:include, MoreValidations)
    Person.validations.should == [
      [:presence_of, :name],
      [:presence_of, :more],
      [:presence_of, :phone],
      [:presence_of, :email]
    ]
  end

  it "should be inheritable when defined in base class"  
  it "should implement basic validations"
  
end  