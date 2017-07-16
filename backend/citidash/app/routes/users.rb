  module CitiDash
    module Routes
      class Users < Base
        use JwtAuth

        get '/profile' do
          profile = {
            first_name: current_user.first_name,
            last_name: current_user.last_name,
            name: current_user.short_name
          }

          json_result_wrapper(profile, request)
        end

        get '/profile/stats' do 
          stats = current_user.statistics
          result = {
            trip_count: stats.trip_count,
            total_duration: stats.total_duration_in_seconds,
            total_distance: stats.distance_travelled,
            yellow_jerseys: Leaderboard.yellow_jerseys_for_user(current_user.id).count
          }
          json_result_wrapper(result, request)
        end

        get '/profile/trips' do 
          query = Trip.where(user: current_user).eager(:origin, :destination, :user).order(Sequel.desc(:ended_at))
          format_query_json_response(query, request) do |trips|
            trips.map do |trip|
              {
                id: trip.id,
                started_at: trip.started_at,
                ended_at: trip.ended_at,
                origin: {
                  id: trip.origin.id,
                  name: trip.origin.name
                },
                destination: {
                  id: trip.destination.id,
                  name: trip.destination.name
                }
              }
            end
          end
        end

        get '/profile/routes' do
          query = Leaderboard.most_common_routes_for(current_user.id)
          format_query_json_response(query, request) do |results|
            results.map do |result|
              {
                id: result[:route_id],
                trip_count: result[:trip_count],
                origin: {
                  id: result[:origin_id],
                  name: result[:origin_name]
                },
                destination: {
                  id: result[:destination_id],
                  name: result[:destination_name]
                }
              }
            end
          end
        end

        post '/profile/refresh_data' do
          current_user.refresh_data
          current_user.statistics.to_json
        end
      end
    end
  end