# Leaderboard provides leaderboards for trips/routes/stations

module CitiDash
  module Services
    class Leaderboard
      def self.statistics(order_by)
        order_by = order_by || :trip_count
        Statistics.eager(:user).order(order_by)
      end

      def self.most_common_routes_for(user_id)
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
          WHERE t.user_id = ?
          group by t.route_id, os.id, os.name, ds.id, ds.name
          order by trip_count desc
        SQL
        
        query = DB[query_string, user_id]
      end
      
      def self.most_common_routes
        query = DB[%{
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

        # Paginate.paginate_and_format_query(query, page[:offset], page[:limit]) do |results|
        #   results.map do |result|
        #     {
        #       id: result[:route_id],
        #       trip_count: result[:trip_count],
        #       origin: {
        #         id: result[:origin_id],
        #         name: result[:origin_name]
        #       },
        #       destination: {
        #         id: result[:destination_id],
        #         name: result[:destination_name]
        #       }
        #     }
        #   end
        # end
      end

      def self.fastest_trips_for_route(route_id)
        query = DB[%{
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
          }, route_id]
      end

      def self.fastest_users_for_route(route_id)
        query = DB[%{
          SELECT 
              DISTINCT ON (u.id) u.id as user_id, 
              r.id, 
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
        }, route_id]
      end

      def self.yellow_jerseys_for_user(user_id)
        query = DB[%{
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
          }, user_id]       
      end

      def self.yellow_jersey_for_route(route_id)
        query = DB[%{
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
        }, route_id].first
      end
    end
  end
end
