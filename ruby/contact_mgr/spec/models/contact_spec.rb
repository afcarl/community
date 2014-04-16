require 'spec_helper'
require 'contact'

describe Contact do

  describe "birthday and age" do

    it "should not calculate age if birthday is nil" do
      c = FactoryGirl.create(:contact, birthday: nil)
      c.age.should be_nil
    end

    it "should calculate age if birthday is not nil" do
      c = FactoryGirl.create(:contact, birthday: '1977-12-01'.to_date)
      c.age.should == 36
    end
  end

  describe "validations" do

    def assert_validation_exception(e, expected_msg)
      #e.class.name.should == 'ActiveRecord::RecordInvalid'
      e.message.should    == expected_msg
    end

    it "should create a valid instance with the default factory" do
      begin
        c = FactoryGirl.create(:contact)
        c.id.should > 0
      rescue Exception => e
        fail('no exception was expected')
      end
    end

    it "should not allow a nil or short name value" do
      begin
        c = FactoryGirl.create(:contact, name: nil)
        fail('a validation error was expected')
      rescue Exception => e
        e.class.name.should == 'ActiveRecord::RecordInvalid'
        e.message.should    == 'Validation failed: Name is too short (minimum is 4 characters)'
      end
      begin
        c = FactoryGirl.create(:contact, name: 'chr')
        fail('a validation error was expected')
      rescue Exception => e
        assert_validation_exception(e, 'Validation failed: Name is too short (minimum is 4 characters)')
      end
    end

    it "should not allow a nil or undefined sex" do
      begin
        c = FactoryGirl.create(:contact, sex: nil)
        fail('a validation error was expected')
      rescue Exception => e
        assert_validation_exception(e, 'Validation failed: Sex  is not a valid sex')
      end
      begin
        c = FactoryGirl.create(:contact, sex: 'rspec')
        fail('a validation error was expected')
      rescue Exception => e
        assert_validation_exception(e, 'Validation failed: Sex rspec is not a valid sex')
      end
    end

    it "should not allow negative or floating-point age value" do
      begin
        c = FactoryGirl.create(:contact, birthday: nil, age: -1)
        fail('a validation error was expected')
      rescue Exception => e
        assert_validation_exception(e, 'Validation failed: Age must be greater than or equal to 0')
      end
      begin
        c = FactoryGirl.create(:contact, birthday: nil, age: 33.3)
        fail('a validation error was expected')
      rescue Exception => e
        assert_validation_exception(e, 'Validation failed: Age must be an integer')
      end
    end

    it "should not allow an empty email, but not a malformed email" do
      begin
        c = FactoryGirl.create(:contact, email: '')
        c.id.should > 0
        c.email.should be_nil
      rescue Exception => e
        fail('no exception was expected')
      end
      begin
        c = FactoryGirl.create(:contact, email: 'mal!formeD')
        fail('a validation error was expected')
      rescue Exception => e
        assert_validation_exception(e, 'Validation failed: Email is invalid')
      end
    end

    it "should not allow a nil or short street value" do
      begin
        c = FactoryGirl.create(:contact, street: nil)
        fail('a validation error was expected')
      rescue Exception => e
        e.class.name.should == 'ActiveRecord::RecordInvalid'
        e.message.should    == 'Validation failed: Street is too short (minimum is 4 characters)'
      end
      begin
        c = FactoryGirl.create(:contact, street: '123')
        fail('a validation error was expected')
      rescue Exception => e
        assert_validation_exception(e, 'Validation failed: Street is too short (minimum is 4 characters)')
      end
    end

    it "should not allow a nil or short city value" do
      begin
        c = FactoryGirl.create(:contact, city: nil)
        fail('a validation error was expected')
      rescue Exception => e
        e.class.name.should == 'ActiveRecord::RecordInvalid'
        e.message.should    == 'Validation failed: City is too short (minimum is 2 characters)'
      end
      begin
        c = FactoryGirl.create(:contact, city: 'D')
        fail('a validation error was expected')
      rescue Exception => e
        assert_validation_exception(e, 'Validation failed: City is too short (minimum is 2 characters)')
      end
    end

    it "should not allow a nil or short state value" do
      begin
        c = FactoryGirl.create(:contact, state: nil)
        fail('a validation error was expected')
      rescue Exception => e
        e.class.name.should == 'ActiveRecord::RecordInvalid'
        e.message.should    == 'Validation failed: State is too short (minimum is 2 characters)'
      end
      begin
        c = FactoryGirl.create(:contact, state: 'D')
        fail('a validation error was expected')
      rescue Exception => e
        assert_validation_exception(e, 'Validation failed: State is too short (minimum is 2 characters)')
      end
    end

    it "should not allow a nil or short state value" do
      begin
        c = FactoryGirl.create(:contact, postal_code: nil)
        fail('a validation error was expected')
      rescue Exception => e
        e.class.name.should == 'ActiveRecord::RecordInvalid'
        e.message.should    == 'Validation failed: Postal code is too short (minimum is 5 characters)'
      end
      begin
        c = FactoryGirl.create(:contact, postal_code: 'D')
        fail('a validation error was expected')
      rescue Exception => e
        assert_validation_exception(e, 'Validation failed: Postal code is too short (minimum is 5 characters)')
      end
    end

  end

end
