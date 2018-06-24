require 'rubygems'
require 'bundler'

# Set default env
ENV['RACK_ENV'] ||= 'development'

# Setup load paths
Bundler.require
$LOAD_PATH << File.expand_path('../', __FILE__)
$LOAD_PATH << File.expand_path('../lib', __FILE__)

# Dotenv load specific vars
require 'dotenv'
Dotenv.load(
  File.expand_path("../.env.#{ENV['RACK_ENV']}", __FILE__),
  File.expand_path('../.env', __FILE__)
)

# Require base
require 'sinatra/base'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/json'

Dir['lib/**/*.rb'].sort.each { |file| require file }

require 'app/models'
require 'app/services'
require 'app/helpers'
require 'app/routes'
require 'app/workers'

if ENV['RACK_ENV'] == 'production'
  Sidekiq.configure_server do |config|
    # config.options[:concurrency] = 5
    config.redis = {
      url: ENV['REDIS_URL']
    }
  end
end

module CitiDash
  class App < Sinatra::Application
    configure do
      set :database, lambda {
        ENV['DATABASE_URL'] ||
          "postgres://localhost:5432/citi_dash_#{environment}"
      }
    end

    # configure :development, :staging do
    #   database.loggers << Logger.new(STDOUT)
    # end

    # configure do
    #   disable :method_override
    #   disable :static

    #   set :sessions,
    #       httponly: true,
    #       secure: production?,
    #       secure: false,
    #       expire_after: 5.years,
    #       secret: ENV['SESSION_SECRET']
    # end

    Dir['config/initializers/*.rb'].sort.each { |file| require file }

    # use Rack::Deflater

    # Other routes:
    use Routes::Authentication
    use Routes::MetaRoutes
    use Routes::Users
    use Routes::Stats
    use Routes::Courses
    use Routes::Trips
    use Routes::Friendships
    use Routes::Notifications
  end
end

include CitiDash
include CitiDash::Models
include CitiDash::Services
include CitiDash::Workers

Sequel::Model.plugin :timestamps, :create => :created_at, :update => :updated_at, :update_on_create => true
DB = Sequel.connect(CitiDash::App.database, max_connections: 10, logger: Logger.new('log/db.log'))
