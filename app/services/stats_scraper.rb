module CitiDash
  module Services
    class StatsScraper
      def initialize(user)
        @user = user
      end

      def load_stats
        agent = Authenticator.get_authenticated_agent(@user)
        scrape_stats(agent)
      end

      def scrape_stats(agent)
        if !agent.page.uri.to_s == "https://member.citibikenyc.com/profile/"
          agent.get("https://member.citibikenyc.com/profile/")
        end

        page = agent.page

        statistics = Statistics.find_or_create(user_id: @user.id)
        trip_count = page.search("div.ed-panel__info__value_member-stats-for-period_lifetime")[0].text.to_i
        duration_string = page.parser.xpath("//div[.='Total usage time']/following-sibling::div[1]")[0].text
        distance_string = page.parser.xpath("//div[.='Distance traveled (estimated)']/following-sibling::div[1]")[0].text

        # Parse duration string ("x hours y minutes z seconds") into seconds
        duration_in_seconds = 0
        time_components = duration_string.split(" ").select.each_with_index { |_, i| i.even? }
        time_components.reverse.each_with_index do |value, i|
          duration_in_seconds += value.to_i * (60 ** i)
        end

        # Parse distance travelled into plain miles string
        puts distance_string
        distance = distance_string.split("\u00A0miles")[0].gsub(",","").to_i

        statistics.update({
          trip_count: trip_count,
          total_duration_in_seconds: duration_in_seconds,
          distance_travelled: distance
        })
      end
    end
  end
end