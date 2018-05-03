require 'net/http'

module CitiDash
  module Services
    class RouteMapGenerator

      MAPBOX_API_TOKEN = ENV["MAPBOX_API_TOKEN"]
      MAPBOX_PIN_URL = "https://s3.amazonaws.com/dockdash/assets/images/mapbox_pin@2x.png"

      def initialize(route_id)
        @route = Route.find(id: route_id)
        @origin = @route.origin
        @destination = @route.destination
      end

      def directions
        origin_coords = "#{@origin.lon},#{@origin.lat}"
        destination_coords = "#{@destination.lon},#{@destination.lat}"

        url = "https://api.mapbox.com/directions/v5/mapbox/walking/#{origin_coords};#{destination_coords}?geometries=polyline&access_token=#{MAPBOX_API_TOKEN}"
        
        uri = URI(url)
        response = Net::HTTP.get(uri)
        JSON.parse(response)
      end

      def map_url
        origin_coords = "#{@origin.lon},#{@origin.lat}"
        destination_coords = "#{@destination.lon},#{@destination.lat}"

        begin
          path = directions["routes"][0]["geometry"]
          path_color = "FFCC00"
          path_width = 5
          path_opacity = 1
          pin_url = CGI.escape(MAPBOX_PIN_URL)


          base_map_url = "https://api.mapbox.com/styles/v1/hcurotta/cjelfept5afak2smsuyqg6uxc/static/"
          path_string = "path-#{path_width}+#{path_color}-#{path_opacity}(#{path}),"
          origin_pin_string = "url-#{pin_url}(#{origin_coords}),"
          destination_pin_string = "url-#{pin_url}(#{destination_coords})"
          zoom_and_size = "/auto/400x400@2x"
          query_string = "?access_token=#{MAPBOX_API_TOKEN}&attribution=false&logo=false"

          base_map_url + path_string + origin_pin_string + destination_pin_string + zoom_and_size + query_string
        rescue
          "placeholder"
        end
      end
    end
  end
end
