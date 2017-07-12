require 'spec_helper'

RSpec.describe StatsScraper, :type => :service do
  context 'when scraping stats' do
    use_vcr_cassette "trips"

    before(:each) do 
      @user = User.create({
        :email=>"test@gmail.com",
        :password=>"passtest007",
        :first_name=>"ABC",
        :last_name=>"XYZ",
        :citibike_id=>"NU7S9DAK-1"
      })

      @agent = Authenticator.get_authenticated_agent(@user)
      StationLoader.refresh_stations
    end

    it "scrapes a list of all the user's trips" do 
      scraper = TripScraper.new(@user)
      scraper.scrape_trips(@agent)
      expect(Trip.count).to eq(276)
    end

  end
end