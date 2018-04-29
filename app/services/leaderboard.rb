# Leaderboard provides leaderboards for trips/routes/stations

module CitiDash
  module Services
    class Leaderboard
      def self.statistics(order_by)
        order_by_map = {
          nil => :trip_count,
          "trip_count" => :trip_count,
          "total_duration" => :total_duration_in_seconds,
          "total_distance" => :distance_travelled,
        }

        order_by = order_by_map[order_by]
        query = Statistics.eager(:user)
        query = query.reverse(order_by.to_sym) if order_by
        query
      end

      def self.most_common_routes_for(user_id)
        query_string = <<-SQL 
          SELECT 
            t.route_id,
            os.id AS origin_id,
            os.name AS origin_name,
            os.lat AS origin_lat,
            os.lon AS origin_lon,
            ds.id as destination_id,
            ds.name as destination_name, 
            ds.lat AS destination_lat,
            ds.lon AS destination_lon,
            count(r.id) as trip_count
          FROM trips AS t
          RIGHT JOIN routes as r
              ON r.id = t.route_id
          INNER JOIN stations as os
              on os.id = t.origin_id
          INNER join stations as ds
              on ds.id = t.destination_id
          WHERE t.user_id = ?
          group by t.route_id, os.id, os.name, ds.id, ds.name
          order by trip_count desc
        SQL
        
        DB[query_string, user_id]
      end
      
      def self.most_common_routes
        query_string = <<-SQL 
          SELECT 
            t.route_id,
            os.id AS origin_id,
            os.name AS origin_name,
            ds.id as destination_id,
            ds.name as destination_name, 
            count(r.id) as trip_count
          FROM trips AS t
          RIGHT JOIN routes as r
              ON r.id = t.route_id
          INNER JOIN stations as os
              on os.id = t.origin_id
          INNER join stations as ds
              on ds.id = t.destination_id
          group by t.route_id, os.name, ds.name, os.id, ds.id
          order by trip_count desc
        }]
        SQL

        DB[query_string]
      end

      def self.fastest_trips_for_route(route_id)
        query_string = <<-SQL
          SELECT 
              r.id, 
              os.id AS origin_id,
              os.name AS origin_name,
              ds.id as destination_id,
              ds.name as destination_name, 
              u.short_name as user_short_name,
              t.duration_in_seconds,
              t.ended_at
          FROM routes as r
          INNER JOIN trips as t 
              on t.route_id = r.id
          INNER JOIN stations as os
              on os.id = r.origin_id
          INNER JOIN stations as ds
              on ds.id = r.destination_id
          INNER JOIN users as u 
              on t.user_id = u.id
          WHERE
              r.id = ?
          ORDER BY t.duration_in_seconds ASC
          SQL

          DB[query_string, route_id]
      end

      def self.fastest_users_for_route(route_id)
        query_string = <<-SQL
          SELECT 
              DISTINCT ON (u.id) u.id as user_id, 
              r.id, 
              t.id as trip_id,
              os.id AS origin_id,
              os.name AS origin_name,
              ds.id as destination_id,
              ds.name as destination_name, 
              u.short_name as user_short_name,
              t.duration_in_seconds as duration_in_seconds,
              t.ended_at
              
          FROM routes as r
          INNER JOIN trips as t 
              on t.route_id = r.id
          INNER JOIN stations as os
              on os.id = r.origin_id
          INNER JOIN stations as ds
              on ds.id = r.destination_id
          INNER JOIN users as u 
              on t.user_id = u.id
          WHERE
              r.id = ?
          ORDER BY u.id, t.duration_in_seconds ASC
        SQL

        DB[query_string, route_id]
      end

      def self.yellow_jerseys_for_user(user_id)
        query_string = <<-SQL
          SELECT 
            r.id, 
            u.id as user_id,
            os.id as origin_id,
            os.name as origin_name,
            ds.id as destination_name,
            ds.name as destination_name,
            min(t.duration_in_seconds) as fastest_time
          FROM routes as r
          INNER JOIN trips as t 
            on t.route_id = r.id
          INNER JOIN stations as os
            on os.id = r.origin_id
          INNER JOIN stations as ds
            on ds.id = r.destination_id
          INNER JOIN users as u 
            on t.user_id = u.id
          WHERE
            u.id = ?
          GROUP BY r.id, u.id, os.id, os.name, ds.id, ds.name
          SQL

          DB[query_string, user_id]       
      end

      def self.yellow_jersey_for_route(route_id)
        query_string = <<-SQL
          SELECT 
            r.id, 
            u.id as user_id,
            u.short_name as user_short_name,
            min(t.duration_in_seconds) as fastest_time
          FROM routes as r
          INNER JOIN trips as t 
            on t.route_id = r.id
          INNER JOIN users as u 
            on t.user_id = u.id
          GROUP BY r.id, u.id
          HAVING
            r.id = ?
        SQL
        DB[query_string, route_id].first
      end
    end
  end
end
