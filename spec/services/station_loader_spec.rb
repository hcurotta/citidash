require 'spec_helper'

RSpec.describe StationLoader, :type => :service do
  context 'when loading stations', vcr: true do
    it "should retrieve all stations and save them" do 
      StationLoader.refresh_stations
      stations = Station.dataset
      station = stations.first
      expect(stations.count).to eq(812)
      expect(station.citibike_station_id).to eq(72)
      expect(station.name).to eq("W 52 St & 11 Ave")
      expect(station.lat).to eq(40.76727216)
      expect(station.lon).to eq(-73.99392888)
    end

  end
end