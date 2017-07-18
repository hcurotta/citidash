ENV['RACK_ENV'] = 'test'

require File.expand_path('../../app', __FILE__)

require 'pry'
require 'rspec'
require 'rack/test'
require 'webmock/rspec'
require 'vcr'
require 'database_cleaner'

RSpec.configure do |config|
  include Rack::Test::Methods
  config.extend VCR::RSpec::Macros

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

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end