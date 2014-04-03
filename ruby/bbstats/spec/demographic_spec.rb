require 'spec_helper'

describe "BBStats::Demographic" do

  before do
    @willie = BBStats::Demographic.new(%w(mayswi01 1931 Willie Mays))
  end

  it "should have the correct player_id" do
    @willie.player_id.should == 'mayswi01'
  end

  it "should have the correct birth_year" do
    @willie.birth_year.should == '1931'
  end

  it "should have the correct first_name" do
    @willie.first_name.should == 'Willie'
  end

  it "should have the correct last_name" do
    @willie.last_name.should == 'Mays'
  end

  it "should have the correct full_name" do
    @willie.full_name.should == 'Willie Mays'
  end

end
