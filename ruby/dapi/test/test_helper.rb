require 'simplecov'
SimpleCov.start 'rails' do
  add_group  'Libraries', 'lib/'
  # Explicitly omit directories and files with 'add_filter'
  add_filter 'features/'
  add_filter 'test/'
  add_filter 'vendor/'
end
SimpleCov.command_name 'dapi-minitest'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/spec'
require 'minitest/mock'
require 'minitest/autorun'
require 'minitest/reporters'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'factory_girl'

require_relative 'common/db_helpers'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

DatabaseCleaner.strategy = :transaction

class MiniTest::Spec
  before :each do
    Rails.cache.clear
    DatabaseCleaner.start
  end

  after :each do
    Rails.cache.clear
    DatabaseCleaner.clean
  end
end
