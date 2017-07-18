module CitiDash
  module Routes
    autoload :Base, 'app/routes/base'

    # Other routes:
    autoload :Authentication, 'app/routes/authentication'
    autoload :Users, 'app/routes/users'
    autoload :Stats, 'app/routes/stats'
    autoload :TripRoutes, 'app/routes/trip_routes'
  end
end