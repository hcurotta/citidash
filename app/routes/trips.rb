module CitiDash
  module Routes
    class Trips < Base
      use JwtAuth

      get '/trips' do
        query = TripQueries.all_trips(params)

        format_query_json_response(query, request) do |results|
          results.map do |result|
            {
              id: result[:trip_id],
              started_at: result[:started_at],
              ended_at: result[:ended_at],
              duration_in_seconds: result[:duration_in_seconds],
              user: {
                id: result[:user_id],
                first_name: result[:user_first_name],
                last_name: result[:user_last_name],
                name: result[:user_short_name],
              },
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

      get '/trips/:id' do
        trip = Trip.where(id: params[:id]).eager(:user, :origin, :destination).first

        {
          id: trip.id,
          duration_in_seconds: trip.duration_in_seconds,
          started_at: trip.started_at,
          ended_at: trip.ended_at,
          user: {
            id: trip.user_id,
            first_name: trip.user.first_name,
            last_name: trip.user.last_name,
            name: trip.user.short_name
          },
          route: {
            id: trip.route_id,
            origin: {
              id: trip.origin.id,
              name: trip.origin.name,
              lat: trip.origin.lat,
              lon: trip.origin.lon
            },
            destination: {
              id: trip.destination.id,
              name: trip.destination.name,
              lat: trip.destination.lat,
              lon: trip.destination.lon
            }
          }
        }.to_json
      end

      
    end
  end
end