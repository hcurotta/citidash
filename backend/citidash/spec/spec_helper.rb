ENV['RACK_ENV'] = 'test'

require File.expand_path('../../app', __FILE__)

require 'pry'
require 'rspec'
require 'rack/test'
require 'database_cleaner'
# require 'webmock/rspec'

RSpec.configure do |config|
  include Rack::Test::Methods
  config.order = 'random'

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  def app
    CitiDash::App
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
