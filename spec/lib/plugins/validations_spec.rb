require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "Validations" do
  
  module ContactsValidations
    include Validations
    validate_presence_of :phone
    validate_presence_of :email
  end
  
  module MoreValidations
    include Validations
    include ContactsValidations
    validate_presence_of :more
  end
  
  class Person
    include Validations
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