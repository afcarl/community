require 'simplecov'
SimpleCov.start 'rails' do
  add_group  'Libraries', 'lib/'
  add_group  'Utils',     'app/utils'
  add_filter 'vendor/'
end
SimpleCov.command_name 'deal'


ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
end
