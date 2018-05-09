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

        url = "https://api.mapbox.com/directions/v5/mapbox/cycling/#{origin_coords};#{destination_coords}?geometries=polyline&access_token=#{MAPBOX_API_TOKEN}"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        JSON.parse(response)
      end

      def map_url
        origin_coords = "#{@origin.lon},#{@origin.lat}"
        destination_coords = "#{@destination.lon},#{@destination.lat}"

        begin
          path = CGI.escape(directions["routes"][0]["geometry"])
          path_color = "FFCC00"
          path_width = 5
          path_opacity = 1
          pin_url = CGI.escape(MAPBOX_PIN_URL)


          base_map_url = "https://api.mapbox.com/styles/v1/hcurotta/cjelfept5afak2smsuyqg6uxc/static/"
          path_string = "path-#{path_width}+#{path_color}-#{path_opacity}(#{path})"
          origin_pin_string = ",url-#{pin_url}(#{origin_coords})"
          destination_pin_string = ",url-#{pin_url}(#{destination_coords})"
          zoom = "/auto/"
          thumb_size = "100x100@2x"
          small_size = "300x200@2x"
          large_size = "545x545@2x"
          query_string = "?access_token=#{MAPBOX_API_TOKEN}&attribution=false&logo=false"

          {
            thumbnail:  base_map_url + path_string + zoom + thumb_size + query_string,
            small_size: base_map_url + path_string + zoom + small_size + query_string,
            large_size: base_map_url + path_string + origin_pin_string + destination_pin_string + zoom + large_size + query_string
          }
        rescue
          {
            thumbnail: "thumb_placeholder",
            small_size: "small_placeholder",
            large_size: "large_placeholder"
          }
        end
      end
    end
  end
end
