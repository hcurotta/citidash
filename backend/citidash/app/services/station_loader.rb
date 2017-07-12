require 'net/http'

module CitiDash
  module Services
    class StationLoader
      def self.refresh_stations
        url = "https://api-core.citibikenyc.com/gbfs/en/station_information.json"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        response_data = JSON.parse(response)["data"]

        response_data["stations"].each do |data|
          station = Station.find_or_create(citibike_station_id: data["station_id"])
          station.update({
            name: data["name"],
            lat: data["lat"],
            lon: data["lon"]
          })
        end
      end
    end
  end
end



