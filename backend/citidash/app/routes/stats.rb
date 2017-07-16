module CitiDash
  module Routes
    class Stats < Base
      use JwtAuth

      get '/stats' do
        query = Leaderboard.statistics(params[:order_by], params)
        format_query_json_response(query, request) do |stats|
          stats.map do |stat|
            {
              id: stat.id,
              trip_count: stat.trip_count,
              total_duration_in_seconds: stat.total_duration_in_seconds,
              distance_travelled: stat.distance_travelled,
              user: {
                id: stat.user.id,
                name: stat.user.user_short_name
              }
            }
          end
        end
      end

    end
  end
end