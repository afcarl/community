require 'spec_helper'

describe "BBStats module constants" do

  it "should have the correct VERSION" do
    BBStats::VERSION.should == '0.1.0'
  end

  it "should have the correct DATE" do
    BBStats::DATE.should == '2014-04-03'
  end

  it "should have the correct AUTHOR" do
    BBStats::AUTHOR.should == 'Christopher Joakim'
  end

  it "should have the correct EMAIL" do
    BBStats::EMAIL.should == 'christopher.joakim@gmail.com'
  end

  it "should have a DEFAULT_BATTING_CSV" do
    BBStats::DEFAULT_BATTING_CSV.should == 'data/batting.csv'
  end

  it "should have a DEFAULT_PITCHING_CSV" do
    BBStats::DEFAULT_PITCHING_CSV.should == 'data/pitching.csv'
  end

  it "should have a DEFAULT_DEMOGRAPHIC_CSV" do
    BBStats::DEFAULT_DEMOGRAPHIC_CSV.should == 'data/demographic.csv'
  end
end
