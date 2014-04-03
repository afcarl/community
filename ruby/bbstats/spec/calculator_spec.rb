require 'spec_helper'

describe "BBStats::Calculator" do

  def standard_options
    opts = {}
    opts[:batting_csv]     = BBStats::DEFAULT_BATTING_CSV
    opts[:pitching_csv]    = BBStats::DEFAULT_PITCHING_CSV
    opts[:demographic_csv] = BBStats::DEFAULT_DEMOGRAPHIC_CSV
    opts[:team]    = 'OAK'
    opts[:year]    = '2010'
    opts[:verbose] = false
    opts
  end

  before do
    @calc = BBStats::Calculator.new(standard_options)
  end

  it "should implement verbose?" do
    @calc.verbose?.should be_false
  end

  it "should implement calc_most_improved_avg" do
    result = @calc.calc_most_improved_avg
    result.class.name.should       == 'Hash'
    result[:curr].year.should      == 2010
    result[:curr].player_id.should == 'hamiljo03'
    result[:prev].year.should      == 2009
    result[:prev].player_id.should == 'hamiljo03'
    result[:diff].should be_within(0.001).of(91.2162)
  end

  it "should implement calc_slugging_pct_for_team" do
    result = @calc.calc_slugging_pct_for_team
    result.class.name.should == 'Hash'
    result[:team_id].should  == 'OAK'
    result[:year].should     == 2010
    result[:spct].should be_within(0.001).of(377.93685)
  end

  it "should implement identify_triple_crown_winners, and return no winners for 2010" do
    result = @calc.identify_triple_crown_winners
    result.class.name.should == 'Array'
    result.size.should == 0
  end

  it "should implement identify_triple_crown_winners, and return a winner for 2012" do
    opts = standard_options
    opts[:year] = '2012'
    @calc = BBStats::Calculator.new(opts)
    result = @calc.identify_triple_crown_winners
    result.class.name.should == 'Array'
    result.size.should == 1
    result[0][:year].should   == 2012
    result[0][:league].should == 'AL'
    result[0][:winner].should == 'cabremi01'
    result[0][:demo].full_name.should == 'Miguel Cabrera'
    result[0][:highs][:avg].should be_within(0.001).of(329.58199)
    result[0][:highs][:rbi].should == 139
    result[0][:highs][:homers].should == 44
  end

end
