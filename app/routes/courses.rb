module CitiDash
  module Routes
    # Course refers to Route resources, but since we're in the Routes module, we need to avoid a name clash
    class Courses < Base
      use JwtAuth
      
      get '/routes' do
        query = RouteQueries.all_routes(params)

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
              },
              maps: {
                thumb: result[:route_map_thumb],
                small: result[:route_map_small],
                large: result[:route_map_large]
              }
            }
          end
        end
      end

      get '/routes/:id' do
        route = Route.where(id: params[:id]).eager(:origin, :destination, :trips).first
        fastest_trip = TripQueries.fastest_trip_for(params[:id])

        route_hash = {
          id: route.id,
          maps: {
            thumb: route.map_thumb,
            small: route.map_small,
            large: route.map_large
          },
          origin: {
            id: route.origin.id,
            name: route.origin.name,
            lat: route.origin.lat,
            lon: route.origin.lon
          },
          destination: {
            id: route.destination.id,
            name: route.destination.name,
            lat: route.destination.lat,
            lon: route.destination.lon
          },
          trip_count: route.trips.count,
          fastest_trip: {
            duration_in_seconds: fastest_trip[:duration_in_seconds],
            started_at: fastest_trip[:started_at],
            ended_at: fastest_trip[:ended_at],
            user: {
              id: fastest_trip[:user_id],
              name: fastest_trip[:user_short_name],
              first_name: fastest_trip[:user_first_name],
              last_name: fastest_trip[:user_last_name]
            }
          }
        }.to_json
      end

      get '/routes/:id/users' do
        query = UserQueries.users_of_route(params["id"], params)
        
        format_query_json_response(query, request) do |results|
          results.map do |result|
            {
              id: result[:user_id],
              first_name: result[:user_first_name],
              last_name: result[:user_last_name],
              name: result[:user_short_name],
              fastest_trip_duration_in_seconds: result[:duration_in_seconds],
              trip_count: result[:trip_count],
              last_trip_ended_at: result[:last_trip_ended_at]
            }
          end
        end
      end

      get '/routes/:id/trips' do
        query = TripQueries.trips_on_route(params["id"], params)

        format_query_json_response(query, request) do |results|
          results.map do |result|
            {
              id: result[:trip_id],
              duration_in_seconds: result[:duration_in_seconds],
              started_at: result[:started_at],
              ended_at: result[:ended_at],
              user: {
                id: result[:user_id],
                name: result[:user_short_name],
                first_name: result[:user_first_name],
                last_name: result[:user_last_name]
              }
            }
          end
        end
      end      
    end
  end
end