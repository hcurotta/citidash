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

      def scrape_trips(agent, hard_refresh=false)
        # The page only loads in 16 month increments
        end_date = Time.now
        last_scraped = @user.trips_dataset.order(Sequel.desc(:ended_at)).first.try(:ended_at)

        begin 
          trip_items = []
          start_date = end_date - 16.months

          if !hard_refresh && last_scraped && start_date < last_scraped
            start_date = last_scraped
          end


          formatted_start_date = start_date.strftime("%m/%d/%Y")
          formatted_end_date = end_date.strftime("%m/%d/%Y")
          export_url = "https://member.citibikenyc.com/profile/trips/#{@user.citibike_id}/print?edTripsPrint[startDate]=#{formatted_start_date}&edTripsPrint[endDate]=#{formatted_end_date}"
          puts export_url
          
          page = agent.get(export_url)

          trip_items = page.search("div.ed-table__item_trip")

          trip_items.each do |item|
            trip_start_time = item.search('div.ed-table__item__info__sub-info_trip-start-date').text
            trip_end_time = item.search('div.ed-table__item__info__sub-info_trip-end-date').text
            trip_origin = item.search('div.ed-table__item__info__sub-info_trip-start-station').text
            trip_destination = item.search('div.ed-table__item__info__sub-info_trip-end-station').text

            origin_station = Station.find(name: trip_origin)
            origin_station = Station.create(name: trip_origin, inactive: true) if origin_station.nil?
            
            destination_station = Station.find(name: trip_destination)
            destination_station = Station.create(name: trip_destination, inactive: true) if destination_station.nil?

            next if trip_start_time == "-" || trip_end_time == "-" || trip_origin == "-" || trip_destination == "-"

            started_at = DateTime.strptime(trip_start_time + " EST", "%m/%d/%Y %I:%M:%S %p %z").utc
            ended_at = DateTime.strptime(trip_end_time + " EST", "%m/%d/%Y %I:%M:%S %p %z").utc
            duration = ended_at.to_i - started_at.to_i

            Trip.find_or_create({
              user_id: @user.id,
              origin_id: origin_station.id,
              destination_id: destination_station.id,
              started_at: started_at,
              ended_at: ended_at,
              duration_in_seconds: duration
            })

          end
          end_date = end_date - 16.months
        end while trip_items.count > 0 || (last_scraped && last_scraped != start_date)
      end
    end
  end
end