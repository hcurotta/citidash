require 'spec_helper'

RSpec.describe StatsScraper, :type => :service do
  context 'when scraping stats' do
    before(:each) do 
      VCR.use_cassette("login") do
        @user = User.create({
          :email=>"joebloggs@gmail.com",
          :password=>"testpassword",
          :first_name=>"ABC",
          :last_name=>"XYZ",
          :citibike_id=>"NU7S9DAK-1"
        })
        @agent = Authenticator.get_authenticated_agent(@user)
      end
      VCR.use_cassette("stations") do
        StationLoader.refresh_stations
      end
    end

    it "scrapes a list of all the user's trips" do 
      VCR.use_cassette("all_trips") do
        scraper = TripScraper.new(@user)
        scraper.scrape_trips(@agent)
        expect(Trip.count).to eq(276)
      end
    end

    it "scrapes a only trips since last trip" do 
      VCR.use_cassette("recent_trips") do
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
end