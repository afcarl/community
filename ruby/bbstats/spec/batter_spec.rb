require 'spec_helper'

describe "BBStats::Batter" do

  before do
    @derek = BBStats::Batter.new(%w(jeterde01 2010 AL NYA 157 663 111 179 30 3 10 67 18 5))
    @chris = BBStats::Batter.new(%w(joakimc01 2013 AL NYA   0   0   0   0  0 0  0  0  0 0))
  end

  it "should have the correct player_id" do
    @derek.player_id.should == 'jeterde01'
  end

  it "should have the correct year" do
    @derek.year.should == 2010
  end

  it "should have the correct league" do
    @derek.league.should == 'AL'
  end

  it "should have the correct team_id" do
    @derek.team_id.should == 'NYA'
  end

  it "should have the correct games" do
    @derek.games.should == 157
  end

  it "should have the correct at_bats" do
    @derek.at_bats.should == 663
  end

  it "should have the correct runs" do
    @derek.runs.should == 111
  end

  it "should have the correct hits" do
    @derek.hits.should == 179
  end

  it "should have the correct singles" do
    @chris.singles.should == 0
    @derek.singles.should == 136
  end

  it "should have the correct doubles" do
    @derek.doubles.should == 30
  end

  it "should have the correct triples" do
    @derek.triples.should == 3
  end

  it "should have the correct homers" do
    @derek.homers.should == 10
  end

  it "should have the correct rbi" do
    @derek.rbi.should == 67
  end

  it "should have the correct steals_safe" do
    @derek.steals_safe.should == 18
  end

  it "should have the correct steals_out" do
    @derek.steals_out.should == 5
  end

  it "should have the correct batting_average" do
    @chris.batting_average.should be_within(0.000).of(0.0)
    @derek.batting_average.should be_within(0.001).of(269.9849)
  end

  it "should have the correct slugging_percentage" do
    @chris.slugging_percentage.should be_within(0.000).of(0.0)
    @derek.slugging_percentage.should be_within(0.001).of(369.5324)
  end

  it "should implement has_min_at_bats?" do
    @chris.has_min_at_bats?.should be_false
    @derek.has_min_at_bats?.should be_true

    @chris.has_min_at_bats?(200).should be_false
    @derek.has_min_at_bats?(200).should be_true

    @chris.has_min_at_bats?(700).should be_false
    @derek.has_min_at_bats?(700).should be_false
  end

  it "should implement is_year?" do
    @derek.is_year?(2011).should be_false
    @derek.is_year?(2010).should be_true
  end

  it "should implement id_year_key" do
    @chris.id_year_key.should == 'joakimc01:2013'
    @derek.id_year_key.should == 'jeterde01:2010'
  end

end
