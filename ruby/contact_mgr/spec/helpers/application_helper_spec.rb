require 'spec_helper'
require 'application_helper'

describe ApplicationHelper do

  it "should implement method 'all_contacts'" do
    helper.all_contacts.should == []
    c1 = FactoryGirl.create(:contact)
    c2 = FactoryGirl.create(:contact)
    helper.all_contacts.should == [c1, c2]
  end

  it "should implement method 'current_contact_id'" do
    helper.current_contact_id.should be_nil
    session[:current_contact_id] = 42
    helper.current_contact_id.should == 42
  end

  it "should implement method 'bootstrap_flash_class'" do
    helper.bootstrap_flash_class(nil).should == 'none'
    helper.bootstrap_flash_class('?').should == 'none'
    helper.bootstrap_flash_class(:notice).should == 'bg-success'
    helper.bootstrap_flash_class(:error).should == 'bg-danger'
    helper.bootstrap_flash_class(:alert).should == 'bg-info'
  end

  it "should implement method 'contact_sex_options'" do
    helper.contact_sex_options.should == [["Male", "male"], ["Female", "female"]]
  end

end
