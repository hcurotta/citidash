require 'spec_helper'

RSpec.describe TripScraper, :type => :service, vcr: true do
  context 'when scraping stats' do
    before(:each) do 
      VCR.use_cassette("login") do
        @user = User.create({
          :email=>"hcurotta@gmail.com",
          :password=>"DockDash1",
          :first_name=>"ABC",
          :last_name=>"XYZ",
          :citibike_id=>"NU7S9DAK-1"
        })

        Statistics.create({
          user_id: @user.id,
          last_trip_ended_at: DateTime.parse("October 3rd, 2016 12:30 PM")
        })
        @agent = Authenticator.get_authenticated_agent(@user)
      end
      VCR.use_cassette("stations") do
        StationLoader.refresh_stations
      end
    end

    it "scrapes a list of all the user's trips" do 
      scraper = TripScraper.new(@user)
      scraper.scrape_trips(@agent)
      expect(Trip.count).to eq(276)
    end

    it "scrapes a only trips since last trip" do 
      previous_trip = Trip.create({
        user_id: @user.id,
        ended_at: '09/17/2016'
      })
      scraper = TripScraper.new(@user)
      scraper.scrape_trips(@agent)
      expect(Trip.count).to eq(9)
    end

  end
end