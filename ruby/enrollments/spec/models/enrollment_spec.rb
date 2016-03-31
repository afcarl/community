require 'rails_helper'

RSpec.describe Enrollment, type: :model do

  it "should implement active?" do
    m = Enrollment.new
    expect(m.active?).to eq false
    m.state = ''
    expect(m.active?).to eq false
    m.state = 'active'
    expect(m.active?).to eq true 
    m.state = 'deleted'
    expect(m.active?).to eq false
  end

end
