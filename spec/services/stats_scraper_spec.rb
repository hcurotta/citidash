require 'spec_helper'

RSpec.describe StatsScraper, :type => :service do
  context 'when scraping stats' do
    use_vcr_cassette "stats"

    before(:each) do 
      @user = User.create({
        :email=>"joebloggs@gmail.com",
        :password=>"testpassword",
        :first_name=>"ABC",
        :last_name=>"XYZ",
        :citibike_id=>"NU7S9DAK-1"
      })
    end

    it "scrape down the user's all time stats" do 
      scraper = StatsScraper.new(@user)
      scraper.load_stats
      stats = @user.statistics
      expect(stats.trip_count).to eq(276)
      expect(stats.distance_travelled).to eq(415)
      expect(stats.total_duration_in_seconds).to eq(200380)
    end

  end
end