module CitiDash
  module Routes
    class TripRoutes < Base
      use JwtAuth
      
      get '/routes' do
        query = Route.eager(:origin, :destination)
        format_query_json_response(query, request) do |routes|
          routes.map do |route|
            {
              id: route.id,
              origin: {
                id: route.origin.id,
                name: route.origin.name
              },
              destination: {
                id: route.destination.id,
                name: route.destination.name
              }
            }
          end
        end
      end

      get '/route/:id' do
        route = Route.where(id: params[:id]).eager(:origin, :destination).first
        yellow_jersey = Leaderboard.yellow_jersey_for_route(params[:id])

        route_hash = {
          id: route.id,
          origin: {
            id: route.origin.id,
            name: route.origin.name
          },
          destination: {
            id: route.destination.id,
            name: route.destination.name
          },
          yellow_jersey: {
            user: {
              id: yellow_jersey[:user_id],
              name: yellow_jersey[:user_short_name]
              },
            time: yellow_jersey[:fastest_time]
          }
        }

        json_result_wrapper(route_hash, request)
      end

      get '/route/:id/trips' do
        query = Leaderboard.fastest_trips_for_route(params[:id])

        format_query_json_response(query, request) do |results|
          results.map do |result|
            {
              id: result[:id],
              duration_in_seconds: result[:duration_in_seconds],
              user: {
                id: result[:user_id],
                name: result[:user_short_name]
              },
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
      
      get '/route/:id/users' do
        query = Leaderboard.fastest_users_for_route(params[:id])
        
        format_query_json_response(query, request) do |results|
          results.map do |result|
            {
              id: result[:trip_id],
              duration_in_seconds: result[:duration_in_seconds],
              user: {
                id: result[:user_id],
                name: result[:user_short_name]
              },
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
    end
  end
end