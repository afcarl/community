require 'spec/bluehill_spec_helper.rb'

describe "Class Bluehill::Generator" do
  
  before(:all) do
    Bluehill::Configuration.new('config/bluehill.config')
    Bluehill::Properties.add('global_verbose', 'false')
    @generator = Bluehill::Generator.new
    @generator.generate_project('YourApplication', false)
  end

  it "should implement the method 'project_list' " do
    @generator.project_list[0].should == 'YourApplication'
  end
  
  it "should be testing with the 'YourApplication' project " do
    @generator.project_name.should == 'YourApplication'
  end

  it "should implement the method 'workspace_dir' " do
    @generator.workspace_dir.should == '/fb302'
  end

  it "should implement the method 'src_dir' " do
    @generator.src_dir.should == '/fb302/YourApplication/src'
  end
  
  it "should implement the method 'root_package' " do
    @generator.root_package.should == 'com.yourdomain.yourapp'
  end  
  
end
