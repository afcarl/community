require 'simplecov'
SimpleCov.start

puts "loading spec_helper"

require 'bbstats'

RSpec.configure do | config |
  config.color_enabled = true
  config.formatter     = 'documentation'
end
