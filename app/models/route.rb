module CitiDash
  module Models
    class Route < Sequel::Model(:routes)
      many_to_one :origin, class: :Station
      many_to_one :destination, class: :Station
      one_to_many :trips

      def after_create
        RouteMapperWorker.perform_async(id)
      end

      def active?
        origin.inactive || destination.inactive
      end
    end
  end
end
