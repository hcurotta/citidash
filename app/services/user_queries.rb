module CitiDash
  module Services
    class UserQueries
      def self.find_user(query)
        query_string = <<-SQL 
          SELECT 
            id,
            first_name,
            last_name,
            short_name,
            email
          FROM 
            users
          WHERE
            concat_ws(' ', first_name, last_name, email) ILIKE ? 
        SQL

        DB[query_string, "%#{query.squish}%"]
      end

      # TODO Implement friends only filter
      def self.users_of_route(route_id, options={})
        valid_order_by = ["last_trip_ended_at", "trip_count", "duration_in_seconds"]

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
              r.id,
              u.id as user_id,
              u.short_name as user_short_name,
              u.first_name as user_first_name,
              u.last_name as user_last_name,
              min(t.duration_in_seconds) as duration_in_seconds,
              max(t.ended_at) as last_trip_ended_at,
              count(r.id) as trip_count
          FROM routes as r
          INNER JOIN trips as t 
              on t.route_id = r.id
          INNER JOIN users as u 
              on t.user_id = u.id
          WHERE
              r.id = ?
          GROUP BY r.id, u.id
          ORDER BY #{order_by}
        SQL

        DB[query_string, route_id]
      end
    end
  end
end