require 'spec/bluehill_spec_helper.rb'

describe "Class Bluehill::Properties" do
  
  before(:all) do
    Bluehill::Configuration.new('config/bluehill.config')
    Bluehill::Properties.add('global_verbose', 'false')
  end

  it "should enable setting and querying verbose?" do
    Bluehill::Properties.verbose?.should == false
    Bluehill::Properties.add('global_verbose', 'true')
    Bluehill::Properties.verbose?.should == true
  end

  it "should enable setting and querying overwrite?" do
    Bluehill::Properties.overwrite?.should == true
  end
    
  it "should implement 'project_list'" do
    list = Bluehill::Properties.project_list
    list[0].should == 'YourApplication'
  end
  
  it "should implement 'events_for_project' " do
    list = Bluehill::Properties.events_for_project('YourApplication')
    list.should_not be_nil
  end

end
