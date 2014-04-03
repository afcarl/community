require 'spec_helper'

describe "BBStats::Datastore" do

  before do
    opts = {}
    opts[:batting_csv]     = BBStats::DEFAULT_BATTING_CSV
    opts[:pitching_csv]    = BBStats::DEFAULT_PITCHING_CSV
    opts[:demographic_csv] = BBStats::DEFAULT_DEMOGRAPHIC_CSV
    opts[:team]    = ''
    opts[:year]    = '2007'
    opts[:verbose] = false
    BBStats::Datastore.load(opts)
  end

  it "should implement method error?" do
    BBStats::Datastore.error?.should be_false
  end

  it "should return an Array of the two leagues in MLB" do
    BBStats::Datastore.leagues.should == ['AL', 'NL']
  end

  it "should return an Array of pitchers" do
    BBStats::Datastore.pitchers.should == []
  end

  it "should return an Hash of demographics" do
    BBStats::Datastore.demographics.class.name.should == 'Hash'
    BBStats::Datastore.demographics.size.should > 17000
    BBStats::Datastore.demographics.size.should < 20000
    dj = BBStats::Datastore.demographics['jeterde01']
    dj.full_name.should == 'Derek Jeter'
  end

  it "should return an Hash of batter_ids" do
    BBStats::Datastore.batter_ids.class.name.should == 'Hash'
    BBStats::Datastore.batter_ids.size.should > 2400
    BBStats::Datastore.batter_ids.size.should < 2500
    BBStats::Datastore.batter_ids.has_key?('jeterde01').should be_true
  end

  it "should have the correct sorted_batter_ids" do
    BBStats::Datastore.sorted_batter_ids.size.should == 2447
    BBStats::Datastore.sorted_batter_ids.include?('jeterde01').should be_true
    BBStats::Datastore.sorted_batter_ids.include?('joakimc01').should be_false
    BBStats::Datastore.sorted_batter_ids[0].should  == 'aardsda01'
    BBStats::Datastore.sorted_batter_ids[-1].should == 'zumayjo01'
  end

  it "should implement batter_for_year" do
    BBStats::Datastore.batter_for_year('nemo', 2014).should be_nil
    dj2010 = BBStats::Datastore.batter_for_year('jeterde01', 2010)
    dj2009 = BBStats::Datastore.batter_for_year('jeterde01', 2009)

    dj2010.should_not be_nil
    dj2009.should_not be_nil

    dj2010.at_bats.should == 663
    dj2009.at_bats.should == 634
  end

end
