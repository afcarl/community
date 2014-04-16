require 'simplecov'
SimpleCov.start 'rails' do
  add_filter 'spec/'
  add_filter 'test/'
  add_filter 'vendor/'
end
SimpleCov.command_name 'cm-cucumber'

require 'cucumber/rails'

ActionController::Base.allow_rescue = false

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

module CMHelpers
  def log_page
    if page
      sio = StringIO.new
      sio << "begin_log_page \n"
      sio << "page status_code:  #{page.status_code} \n"
      sio << "page current_host: #{page.current_host} \n"
      sio << "page current_path: #{page.current_path} \n"
      sio << "page current_url:  #{page.current_url} \n"
      sio << "page body:\n #{page.body} \n"
      sio << "page text:\n #{page.text} \n"
      sio << "end_log_page \n"
      Rails.logger.debug(sio.string)
    end
  end
end

# Mix-in our modules into the Cucumber World object.
World(CMHelpers)

Before do | scenario |
  Rails.logger.debug "before_scenario: #{scenario.title}"
end

After do | scenario |
  Rails.logger.debug "after_scenario: #{scenario.title}"
  log_page if scenario.failed?
end
