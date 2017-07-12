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
    end
  end
end