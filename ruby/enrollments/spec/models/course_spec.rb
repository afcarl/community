require 'rails_helper'

RSpec.describe Course, type: :model do

  it "should implement active?" do
    m = Course.new
    expect(m.active?).to eq false
    m.state = ''
    expect(m.active?).to eq false
    m.state = 'active'
    expect(m.active?).to eq true 
    m.state = 'deleted'
    expect(m.active?).to eq false
  end

end
