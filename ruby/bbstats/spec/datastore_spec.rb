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
    opts
    BBStats::Datastore.load(opts)
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
