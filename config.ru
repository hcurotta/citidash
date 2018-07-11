require './app'
require 'raven'

Raven.configure do |config|
  config.server = 'https://75b0e47fadc34d0a985fc1fb3838ea35:369c500b27e94aa89b7aba635666313f@sentry.io/1241216'
end

use Raven::Rack
run CitiDash::App
