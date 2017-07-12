module CitiDash
  module Services
    class StatsScraper
      def initialize(user)
        @user = user
      end

      def load_stats
        authenticator = Authenticator.new(@user.email, @user.password)
        authenticator.login
        page = authenticator.agent.get("https://member.citibikenyc.com/profile/")
        scrape_stats(page)
      end

      def scrape_stats(page)
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
        distance = distance_string.split(" ")[0].to_i

        statistics.update({
          trip_count: trip_count,
          total_duration_in_seconds: duration_in_seconds,
          distance_travelled: distance
        })
      end
    end
  end
end