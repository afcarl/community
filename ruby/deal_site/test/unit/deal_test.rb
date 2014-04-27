require 'test_helper'

class DealTest < ActiveSupport::TestCase

  test "factory should be sane" do
    assert FactoryGirl.build(:deal).valid?
  end

  test "deal.over? should return false for unexpired deals" do
    deal = FactoryGirl.create(:deal, :end_at => 2.seconds.from_now)
    assert (deal.over? == false), "Deal should not be over"
  end

  test "deal.over? should return true for expired deals" do
    deal = FactoryGirl.create(:deal, :end_at => 2.seconds.ago)
    assert (deal.over?), "Deal should be over"
  end

end
