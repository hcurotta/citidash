module CitiDash
  module Services
    # Other models:
    autoload :Authenticator, 'app/services/authenticator'
    autoload :StatsScraper, 'app/services/stats_scraper'
    autoload :StationLoader, 'app/services/station_loader'
    autoload :TripScraper, 'app/services/trip_scraper'
    autoload :Leaderboard, 'app/services/leaderboard'

    # Query Providers
    autoload :RouteQueries, 'app/services/route_queries'
    autoload :UserQueries, 'app/services/user_queries'
    autoload :TripQueries, 'app/services/trip_queries'
  end
end