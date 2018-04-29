module CitiDash
  module Models
    class Trip < Sequel::Model(:trips)
      many_to_one :user
      many_to_one :route
      many_to_one :origin, class: :Station
      many_to_one :destination, class: :Station

      def before_create
        self.route = Route.find_or_create({
          origin_id: self.origin_id,
          destination_id: self.destination_id
        })
        super
      end

      def self.to_api(collection, with_associations=[])
        nested_objects = {}

        collection.map do |trip|
          if with_associations.include?(:user)
            nested_objects[:user] = trip.user.to_api
          end

          trip.to_api(nested_objects)
        end
      end

      def to_api(nested_objects: {})
        {
          id: self.id,
          started_at: self.started_at,
          ended_at: self.ended_at,
          duration_in_seconds: self.duration_in_seconds,
        }.merge(nested_objects)
      end
    end
  end
end