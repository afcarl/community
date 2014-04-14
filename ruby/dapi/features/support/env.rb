require 'simplecov'
SimpleCov.start 'rails' do
  add_group  'Libraries', 'lib/'
  # Explicitly omit directories and files with 'add_filter'
  add_filter 'features/'
  add_filter 'test/'
  add_filter 'vendor/'
end
SimpleCov.command_name 'dapi-cucumber'

require 'cucumber/rails'
require 'capybara/poltergeist'

# The following modules are in test/common so as to be shared with MiniTest.
require_relative '../../test/common/db_helpers'
require_relative '../../test/common/debugging'

ActionController::Base.allow_rescue = false

class PoltergeistLogger
  @@out = nil
  def self.enable
    @@out = File.new("log/poltergeist.log", "w")
  end
  def self.write(message)
    @@out << "#{message}\n" if @@out
  end
  def self.puts(message)
    @@out << "#{message}\n" if @@out
  end
end
#PoltergeistLogger.enable

Capybara.register_driver :poltergeist do |app|
  driver_config = { debug: false, logger: PoltergeistLogger, phantomjs_logger: PoltergeistLogger }
  Capybara::Poltergeist::Driver.new(app, driver_config)
end
Capybara.javascript_driver = :poltergeist

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

# Mix-in our modules into the Cucumber World object.
World(DBHelpers)
World(Debugging)

Before do | scenario |
  Rails.logger.debug "before_scenario: #{scenario.title}"
end

After do | scenario |
  Rails.logger.debug "after_scenario: #{scenario.title}"
  log_page if scenario.failed?
end
