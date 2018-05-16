# Leaderboard provides leaderboards for trips/routes/stations

module CitiDash
  module Services
    class Leaderboard
      def self.all_stats(options = {})
        valid_order_by = %w(total_duration total_distance)

        order_by = if valid_order_by.include?(options['order_by'])
                     options['order_by']
                   else
                     'trip_count'
                   end
        start_date = options['start_date'] || DateTime.parse('1/1/2000')
        end_date = options['end_date'] || DateTime.now

        query_string = <<-SQL

          SELECT 
              COUNT(t.id) AS trip_count,
              SUM(t.duration_in_seconds) AS total_duration,
              SUM(r.distance)/1000 * 1.6 AS total_distance_real,
              round((7.45 * SUM(t.duration_in_seconds) / 3600)) AS total_distance,
              u.id as user_id,
              u.short_name as user_short_name,
              u.first_name as user_first_name,
              u.last_name as user_last_name
          FROM users AS u
          INNER JOIN trips AS t
              ON t.user_id = u.id
          INNER JOIN routes AS r
              ON t.route_id = r.id
          WHERE t.started_at >= ?
            AND t.ended_at <= ?
          GROUP BY u.id
          ORDER BY #{order_by} desc
        SQL

        DB[query_string, start_date, end_date]
      end
    end
  end
end
