module CitiDash
  module Services
    # Other models:
    autoload :Authenticator, 'app/services/authenticator'
    autoload :StatsScraper, 'app/services/stats_scraper'
    autoload :StationLoader, 'app/services/station_loader'
    autoload :TripScraper, 'app/services/trip_scraper'
    autoload :Leaderboard, 'app/services/leaderboard'
  end
end