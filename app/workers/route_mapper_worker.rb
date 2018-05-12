module CitiDash
  module Workers
    class RouteMapperWorker
      include Sidekiq::Worker

      def perform(route_id)
        route = Route.find(id: route_id)
        route_mapper = RouteMapper.new(route_id)
        route.update(distance: route_mapper.distance)
        route_mapper.send_maps_to_s3!
      end
    end
  end
end