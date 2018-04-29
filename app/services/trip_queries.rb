module CitiDash
  module Services
    class TripQueries

      # TODO implement friends only filter
      def self.all_trips(options={})
        start_date = options["start_date"] || DateTime.parse("1/1/2000")
        end_date = options["end_date"] || DateTime.now

        query_string = <<-SQL 
          SELECT 
            t.id AS trip_id,
            t.started_at,
            t.ended_at,
            t.duration_in_seconds,
            t.route_id as route_id,
            u.id as user_id,
            u.short_name as user_short_name,
            u.first_name as user_first_name,
            u.last_name as user_last_name,
            os.id AS origin_id,
            os.name AS origin_name,
            os.lat AS origin_lat,
            os.lon AS origin_lon,
            ds.id AS destination_id,
            ds.name AS destination_name, 
            ds.lat AS destination_lat,
            ds.lon AS destination_lon
          FROM trips AS t
          RIGHT JOIN users AS u
            ON u.id = t.user_id
          RIGHT JOIN routes AS r
            ON r.id = t.route_id
          INNER JOIN stations AS os
            ON os.id = t.origin_id
          INNER join stations AS ds
            ON ds.id = t.destination_id
          WHERE t.started_at >= ?
            AND t.ended_at <= ?
          GROUP BY t.id, os.id, os.name, ds.id, ds.name, u.id
          ORDER BY t.ended_at desc
        SQL

        DB[query_string, start_date, end_date]
      end

      def self.trips_for(user_id, options={})
        start_date = options["start_date"] || DateTime.parse("1/1/2000")
        end_date = options["end_date"] || DateTime.now

        query_string = <<-SQL 
          SELECT 
            t.id AS trip_id,
            t.started_at,
            t.ended_at,
            t.duration_in_seconds,
            t.route_id as route_id,
            os.id AS origin_id,
            os.name AS origin_name,
            os.lat AS origin_lat,
            os.lon AS origin_lon,
            ds.id AS destination_id,
            ds.name AS destination_name, 
            ds.lat AS destination_lat,
            ds.lon AS destination_lon
          FROM trips AS t
          RIGHT JOIN routes AS r
            ON r.id = t.route_id
          INNER JOIN stations AS os
            ON os.id = t.origin_id
          INNER join stations AS ds
            ON ds.id = t.destination_id
          WHERE t.user_id = ?
            AND t.started_at >= ?
            AND t.ended_at <= ?
          GROUP BY t.id, os.id, os.name, ds.id, ds.name
          ORDER BY t.ended_at desc
        SQL
        
        DB[query_string, user_id, start_date, end_date]
      end

      def self.fastest_trip_for(route_id)
        query = self.trips_on_route(route_id, {"order_by" => "duration_in_seconds"})
        query.first       
      end

      # TODO implement friends only filter
      def self.trips_on_route(route_id, options={})
        valid_order_by = ["last_trip_ended_at", "duration_in_seconds"]

        if valid_order_by.include?(options["order_by"])
          order_by = options["order_by"]
        else
          order_by = "duration_in_seconds"
        end

        if order_by == "duration_in_seconds"
          order_by = order_by + " ASC"
        else
          order_by = order_by + " DESC"
        end

        start_date = options["start_date"] || DateTime.parse("1/1/2000")
        end_date = options["end_date"] || DateTime.now

        query_string = <<-SQL
          SELECT 
            t.id as trip_id,
            r.id as route_id, 
            u.id as user_id,
            u.short_name as user_short_name,
            u.first_name as user_first_name,
            u.last_name as user_last_name,
            t.duration_in_seconds as duration_in_seconds,
            t.started_at as started_at,
            t.ended_at as ended_at
          FROM routes as r
          INNER JOIN trips as t 
            on t.route_id = r.id
          INNER JOIN users as u 
            on t.user_id = u.id
          WHERE r.id = ?
            AND t.started_at >= ?
            AND t.ended_at <= ?
          ORDER BY
            #{order_by}
        SQL
        DB[query_string, route_id, start_date, end_date]
      end
    end
  end
end