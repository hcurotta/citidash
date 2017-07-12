module CitiDash
  module Models
    class User < Sequel::Model(:users)
      one_to_one :statistics
      one_to_many :routes
      one_to_many :trips
      
      def jwt
        payload = {

          user: {
            id: id,
            exp: Time.now.to_i + 60 * 60,
            iat: Time.now.to_i,
          }
        }

        JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
      end

      def refresh_data
        StatsScraper.new(self).load_stats
        TripScraper.new(self).load_trips
      end
    end
  end
end