require 'net/http'
require 'open-uri'

module CitiDash
  module Services
    class RouteMapper
      MAPBOX_API_TOKEN = ENV['MAPBOX_API_TOKEN']
      MAPBOX_PIN_URL = 'https://s3.amazonaws.com/dockdash/assets/images/mapbox_pin@2x.png'.freeze
      MAP_VERSION_DATE = '20180511'.freeze

      def initialize(route_id)
        @route = Route.where(id: route_id).eager(:origin, :destination).first
        @origin = @route.origin
        @destination = @route.destination
      end

      def mappable?
        !(@origin.inactive || @destination.inactive)
      end

      def directions
        @directions ||= get_directions
      end

      def maps
        @maps ||= get_maps
      end

      def distance
        return nil unless mappable?
        # Rounded to nearest metre
        route = directions['routes'][0]
        route ? route['distance'].round : nil
      end

      def send_maps_to_s3!
        return nil unless mappable?

        s3 = Aws::S3::Resource.new

        maps.each do |map_size, url|
          open(url) do |file|
            # Ensure File not String
            if file.is_a?(StringIO)
              tempfile = Tempfile.new
              File.write(tempfile.path, file.string)
              file = tempfile
            end

            name = "#{ENV['RACK_ENV']}/maps/#{@route.id}_#{map_size}_v#{MAP_VERSION_DATE}.png"
            obj = s3.bucket(ENV['AWS_BUCKET']).object(name)
            obj.upload_file(file, acl: 'public-read')
            @route.update("map_#{map_size}" => obj.public_url)
          end
        end
      end

      private

      def get_maps
        origin_coords = "#{@origin.lon},#{@origin.lat}"
        destination_coords = "#{@destination.lon},#{@destination.lat}"

        begin
          path = CGI.escape(directions['routes'][0]['geometry'])
          path_color = 'FFCC00'
          path_width = 5
          path_opacity = 1
          pin_url = CGI.escape(MAPBOX_PIN_URL)

          base_map_url = 'https://api.mapbox.com/styles/v1/hcurotta/cjelfept5afak2smsuyqg6uxc/static/'
          path_string = "path-#{path_width}+#{path_color}-#{path_opacity}(#{path})"
          origin_pin_string = ",url-#{pin_url}(#{origin_coords})"
          destination_pin_string = ",url-#{pin_url}(#{destination_coords})"
          zoom = '/auto/'

          thumb_size = '100x100@2x'
          small_size = '300x200@2x'
          large_size = '545x545@2x'
          query_string = "?access_token=#{MAPBOX_API_TOKEN}&attribution=false&logo=false"

          {
            thumb:  base_map_url + path_string + zoom + thumb_size + query_string,
            small: base_map_url + path_string + zoom + small_size + query_string,
            large: base_map_url + path_string + origin_pin_string + destination_pin_string + zoom + large_size + query_string
          }
        rescue
          nil
        end
      end

      def get_directions
        return nil unless mappable?

        origin_coords = "#{@origin.lon},#{@origin.lat}"
        destination_coords = "#{@destination.lon},#{@destination.lat}"

        url = "https://api.mapbox.com/directions/v5/mapbox/cycling/#{origin_coords};#{destination_coords}?geometries=polyline&access_token=#{MAPBOX_API_TOKEN}"

        uri = URI(url)
        response = open(uri).read
        JSON.parse(response)
      end
    end
  end
end
