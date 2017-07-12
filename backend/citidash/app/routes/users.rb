module CitiDash
  module Routes
    class Users < Base
      use JwtAuth

      get '/profile' do
        current_user.to_json(only: [:first_name, :last_name])
      end

      get '/profile/stats' do 
        current_user.statistics.to_json
      end

      get '/profile/trips' do 
        current_user.trips.to_json
      end

      post '/profile/refresh_data' do
        current_user.refresh_data
        current_user.statistics.to_json
      end
    end
  end
end