module CitiDash
  module Routes
    autoload :Base, 'app/routes/base'

    # Other routes:
    autoload :Authentication, 'app/routes/authentication'
    autoload :Users, 'app/routes/users'
    autoload :Stats, 'app/routes/stats'
    autoload :Courses, 'app/routes/courses'
    autoload :Trips, 'app/routes/trips'
    autoload :Friendships, 'app/routes/friendships'
  end
end
