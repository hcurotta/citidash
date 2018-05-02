  module CitiDash
    module Routes
      class Users < Base
        use JwtAuth

        def user_response(user)
          stats = user.statistics
          
          if user != current_user 
            routes_in_common = RouteQueries.routes_in_common(user, current_user).limit(5).to_a
            routes_in_common.map! do |route|
              {
                "id": route[:route_id],
                "trip_count": route[:trip_count],
                "origin": {
                  "id": route[:origin_id],
                  "name": route[:origin_name],
                  "lat": route[:origin_lat],
                  "lng": route[:origin_lon],
                },
                "destination": {
                  "id": route[:destination_id],
                  "name": route[:destination_name],
                  "lat": route[:destination_lat],
                  "lng": route[:destination_lon],
                },
              }
            end
          else
            routes_in_common = []
          end

          favourite_routes = RouteQueries.routes_for(user.id, {"order_by" => "trip_count"}).limit(5).to_a
          favourite_routes.map! do |route|
            {
              "id": route[:route_id],
              "trip_count": route[:trip_count],
              "origin": {
                "id": route[:origin_id],
                "name": route[:origin_name],
                "lat": route[:origin_lat],
                "lng": route[:origin_lon],
              },
              "destination": {
                "id": route[:destination_id],
                "name": route[:destination_name],
                "lat": route[:destination_lat],
                "lng": route[:destination_lon],
              },
            }
          end

          latest_trips = TripQueries.trips_for(user.id).limit(5).to_a
          latest_trips.map! do |result|
            {
              id: result[:trip_id],
              started_at: result[:started_at],
              ended_at: result[:ended_at],
              duration_in_seconds: result[:duration_in_seconds],
              route: {
                id: result[:route_id],
                origin: {
                  id: result[:origin_id],
                  name: result[:origin_name],
                  lat: result[:origin_lat],
                  lon: result[:origin_lon]
                },
                destination: {
                  id: result[:destination_id],
                  name: result[:destination_name],
                  lat: result[:destination_lat],
                  lon: result[:destination_lon]
                }
              }
            }
          end

          user.to_api({
            stats: stats.to_api,
            latest_trips: latest_trips,
            favourite_routes: favourite_routes,
            routes_in_common: routes_in_common
          }).to_json
        end

        get '/user' do
          user_response(current_user)
        end

        get '/users/:id' do
          user = User.find(id: params["id"])
          user_response(user)
        end


        get '/users' do 
          users = UserQueries.find_user(params["query"])

          format_query_json_response(users, request) do |users|
            users.map do |user|
              {
                id: user[:id],
                first_name: user[:first_name],
                last_name: user[:last_name],
                name: user[:short_name]
              }
            end
          end
        end

        get '/users/:id/routes' do
          query = RouteQueries.routes_for(params["id"], params)

          format_query_json_response(query, request) do |results|
            results.map do |result|
              {
                id: result[:route_id],
                trip_count: result[:trip_count],
                last_trip_ended_at: result[:last_trip_ended_at],
                origin: {
                  id: result[:origin_id],
                  name: result[:origin_name],
                  lat: result[:origin_lat],
                  lon: result[:origin_lon]
                },
                destination: {
                  id: result[:destination_id],
                  name: result[:destination_name],
                  lat: result[:destination_lat],
                  lon: result[:destination_lon]
                }
              }
            end
          end
        end


        get '/users/:id/trips' do
          query = TripQueries.trips_for(params["id"], params)
          
          format_query_json_response(query, request) do |results|
            results.map do |result|
              {
                id: result[:trip_id],
                started_at: result[:started_at],
                ended_at: result[:ended_at],
                duration_in_seconds: result[:duration_in_seconds],
                route: {
                  id: result[:route_id],
                  origin: {
                    id: result[:origin_id],
                    name: result[:origin_name],
                    lat: result[:origin_lat],
                    lon: result[:origin_lon]
                  },
                  destination: {
                    id: result[:destination_id],
                    name: result[:destination_name],
                    lat: result[:destination_lat],
                    lon: result[:destination_lon]
                  }
                }
              }
            end
          end
        end

        ###### Below is Unfinished

        post '/user/refresh_data' do
          current_user.refresh_data!
          current_user.statistics.to_json
        end
      end
    end
  end