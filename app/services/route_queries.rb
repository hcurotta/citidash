module CitiDash
  module Services
    class RouteQueries
      def self.routes_in_common(user_1, user_2)
        user_1_route_ids = user_1.trips.pluck(:route_id)
        user_2_route_ids = user_2.trips.pluck(:route_id)

        common_routes = user_1_route_ids && user_2_route_ids

        if common_routes.any?
          query_string = <<-SQL
            SELECT
              t.route_id as route_id,
              os.id AS origin_id,
              os.name AS origin_name,
              os.lat AS origin_lat,
              os.lon AS origin_lon,
              ds.id as destination_id,
              ds.name as destination_name,
              ds.lat AS destination_lat,
              ds.lon AS destination_lon,
              r.map_thumb AS route_map_thumb,
              r.map_small AS route_map_small,
              r.map_large AS route_map_large,
              count(r.id) as trip_count,
              max(t.ended_at) as last_at,
              min(t.duration_in_seconds) as fastest_time
            FROM
              trips AS t
            RIGHT JOIN routes as r
                ON r.id = t.route_id
            INNER JOIN stations as os
                ON os.id = t.origin_id
            INNER join stations as ds
                ON ds.id = t.destination_id
            WHERE
              r.id IN ?
              AND (t.user_id = ? OR t.user_id = ?)
            GROUP BY
              t.route_id,
              os.id,
              os.name,
              os.lat,
              os.lon,
              ds.id,
              ds.name,
              ds.lat,
              ds.lon,
              r.map_thumb,
              r.map_small,
              r.map_large
            ORDER BY trip_count desc
          SQL

          DB[query_string, common_routes, user_1.id, user_2.id]
        end
      end

      def self.routes_for(user_id, options = {})
        valid_order_by = %w(last_trip_ended_at trip_count)

        order_by = if valid_order_by.include?(options['order_by'])
                     options['order_by']
                   else
                     'trip_count'
                   end

        start_date = options['start_date'] || DateTime.parse('1/1/2000')
        end_date = options['end_date'] || DateTime.now

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
            r.map_thumb AS route_map_thumb,
            r.map_small AS route_map_small,
            r.map_large AS route_map_large,
            count(r.id) as trip_count,
            max(t.ended_at) as last_trip_ended_at
          FROM trips AS t
          RIGHT JOIN routes as r
              ON r.id = t.route_id
          INNER JOIN stations as os
              on os.id = t.origin_id
          INNER join stations as ds
              on ds.id = t.destination_id
          WHERE
            t.user_id = ?
            and t.started_at >= ?
            and t.ended_at <= ?
          group by t.route_id, os.id, os.name, ds.id, ds.name, r.map_thumb, r.map_small, r.map_large
          order by #{order_by} desc
        SQL

        DB[query_string, user_id, start_date, end_date]
      end

      # TODO: implement friends only filter
      def self.all_routes(options = {})
        valid_order_by = %w(last_trip_ended_at trip_count)

        order_by = if valid_order_by.include?(options['order_by'])
                     options['order_by']
                   else
                     'trip_count'
                   end

        start_date = options['start_date'] || DateTime.parse('1/1/2000')
        end_date = options['end_date'] || DateTime.now

        query_string = <<-SQL
          SELECT
            t.route_id AS route_id,
            os.id AS origin_id,
            os.name AS origin_name,
            os.lat AS origin_lat,
            os.lon AS origin_lon,
            ds.id as destination_id,
            ds.name as destination_name,
            ds.lat AS destination_lat,
            ds.lon AS destination_lon,
            r.map_thumb AS route_map_thumb,
            r.map_small AS route_map_small,
            r.map_large AS route_map_large,
            count(r.id) as trip_count,
            max(t.ended_at) as last_trip_ended_at
          FROM trips AS t
          RIGHT JOIN routes as r
              ON r.id = t.route_id
          INNER JOIN stations as os
              on os.id = t.origin_id
          INNER join stations as ds
              on ds.id = t.destination_id
          WHERE
            t.started_at >= ?
            AND t.ended_at <= ?
          group by t.route_id, os.id, os.name, ds.id, ds.name, r.map_thumb, r.map_small, r.map_large
          order by #{order_by} desc
        SQL

        DB[query_string, start_date, end_date]
      end
    end
  end
end
