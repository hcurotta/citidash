module CitiDash
  module Services
    class TripScraper
      def initialize(user)
        @user = user
      end

      def load_trips
        agent = Authenticator.get_authenticated_agent(@user)
        scrape_trips(agent)
      end

      def scrape_trips(agent)
        # The page only loads in 16 month increments
        end_date = Time.now

        begin 
          trip_items = []
          start_date = end_date - 16.months
          formatted_start_date = start_date.strftime("%m/%d/%Y")
          formatted_end_date = end_date.strftime("%m/%d/%Y")
          export_url = "https://member.citibikenyc.com/profile/trips/#{@user.citibike_id}/print?edTripsPrint[startDate]=#{formatted_start_date}&edTripsPrint[endDate]=#{formatted_end_date}"
            
          page = agent.get(export_url)

          trip_items = page.search("div.ed-table__item_trip")

          trip_items.each do |item|
            trip_start_time = item.search('div.ed-table__item__info__sub-info_trip-start-date').text
            trip_end_time = item.search('div.ed-table__item__info__sub-info_trip-end-date').text
            trip_origin = item.search('div.ed-table__item__info__sub-info_trip-start-station').text
            trip_destination = item.search('div.ed-table__item__info__sub-info_trip-end-station').text

            origin_station = Station.find(name: trip_origin)
            
            if origin_station.nil?
              origin_station = Station.create(name: trip_origin, inactive: true)
            end

            destination_station = Station.find(name: trip_destination)

            if destination_station.nil?
              destination_station = Station.create(name: trip_destination, inactive: true)
            end

            started_at = DateTime.strptime(trip_start_time, "%m/%d/%Y %I:%M:%S %p")
            ended_at = DateTime.strptime(trip_end_time, "%m/%d/%Y %I:%M:%S %p")
            duration = ended_at.to_i - started_at.to_i

            Trip.find_or_create({
              user: @user,
              origin: origin_station,
              destination: destination_station,
              started_at: started_at,
              ended_at: ended_at,
              duration_in_seconds: duration
            })
          end
          end_date = end_date - 16.months
        end while trip_items.count > 0
      end
    end
  end
end