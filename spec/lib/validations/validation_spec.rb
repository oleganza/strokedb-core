require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "Validation of" do
  
  before :each do
    @person_cls = Class.new do
      attr_accessor :name, :age, :gender
      attr_accessor :validate_age, :skip_gender
      
      include Validations
      validate_presence_of :name
      validate_kind_of     :age, :type => Integer, :if => :validate_age, :allow => nil
      validate_presence_of :gender, :unless => proc{|d,s| d.skip_gender }
            
      def [](slotname)
        send(slotname)
      end
    end
  end

  def validate(doc)
    doc.class.validations.inject(Validations::Errors.new(doc)) do |errs, v|
      v.validate(doc, errs)
      errs
    end    
  end

  describe "invalid object" do
    before(:each) do
      @person = @person_cls.new
      @person.name         = "Oleg"
      @person.validate_age = true
      @person.skip_gender  = false
      @person.age          = "22"
      @errors = validate(@person)
    end
    
    it "should produce some errors" do
      @errors.map{|e| 
        [e.validation.class, e.validation.slotname.to_sym] 
      }.should == [
        [Validations::Kind::Validation,     :age], 
        [Validations::Presence::Validation, :gender]
      ]
    end
  end
  
  describe "valid object" do
    
    describe "with all attributes" do
      before(:each) do
        @person = @person_cls.new
        @person.name         = "Oleg"
        @person.validate_age = true
        @person.skip_gender  = false
        @person.age          = 22
        @person.gender       = "male"
        @errors = validate(@person)
      end
    
      it "should produce no errors" do
        @errors.should be_empty
      end
    end
    
    describe "with skipped kind_of validation" do
      before(:each) do
        @person = @person_cls.new
        @person.name         = "Oleg"
        @person.validate_age = false
        @person.skip_gender  = false
        @person.gender       = "male"
        @errors = validate(@person)
      end
    
      it "should produce no errors" do
        @errors.should be_empty
      end
    end
    
    describe "with skipped presence_of and kind_of validations" do
      before(:each) do
        @person = @person_cls.new
        @person.name         = "Oleg"
        @person.validate_age = false
        @person.skip_gender  = true
        @errors = validate(@person)
      end
    
      it "should produce no errors" do
        @errors.should be_empty
      end
    end

    describe "with nil instead of numeric value" do
      before(:each) do
        @person = @person_cls.new
        @person.name         = "Oleg"
        @person.validate_age = true
        @person.age = nil
        @person.skip_gender  = true
        @errors = validate(@person)
      end
    
      it "should produce no errors" do
        @errors.should be_empty
      end
    end 
    
  end # describe "valid object"
end
