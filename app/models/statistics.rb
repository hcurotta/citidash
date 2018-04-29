module CitiDash
  module Models
    class Statistics < Sequel::Model(:statistics)
      many_to_one :user

      def to_api(nested_objects: {})
        {
          trip_count: self.trip_count,
          total_duration: self.total_duration_in_seconds,
          total_distance: self.distance_travelled,
        }.merge(nested_objects)
      end
    end
  end
end