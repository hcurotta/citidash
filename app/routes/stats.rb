module CitiDash
  module Routes
    class Stats < Base
      use JwtAuth

      get '/stats' do
        query = Leaderboard.all_stats(params)
        format_query_json_response(query, request) do |results|
          results.map do |result|
            {
              trip_count: result[:trip_count],
              total_duration: result[:total_duration],
              total_distance: result[:total_distance],
              user: {
                id: result[:user_id],
                first_name: result[:user_first_name],
                last_name: result[:user_last_name],
                name: result[:user_short_name]
              }
            }
          end
        end
      end
    end
  end
end
