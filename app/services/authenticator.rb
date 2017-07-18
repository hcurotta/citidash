module CitiDash
  module Services
    class Authenticator
      attr_reader :agent

      def initialize(email, password)
        @email = email
        @password = password
      end

      def self.get_authenticated_agent(user)
        authenticator = self.new(user.email, user.password)
        if authenticator.login
          return authenticator.agent
        end
      end

      def login
        @agent = Mechanize.new
        page = @agent.get("https://member.citibikenyc.com/profile/login")
        form = page.form_with(action: "https://member.citibikenyc.com/profile/login_check")
        form["_username"] = @email
        form["_password"] = @password
        page = form.submit
        return page.uri.to_s == "https://member.citibikenyc.com/profile/"
      end

      def authenticate_user
        if login
          citibike_id = @agent.page.link_with(dom_class: "ed-profile-page__link ed-profile-page__link_btn ed-profile-page__link_modify-member").href.split('/')[3]
          first_name = @agent.page.search('div.ed-panel__info__value_firstname').text
          last_name = @agent.page.search('div.ed-panel__info__value_lastname').text

          user = User.find_or_create(citibike_id: citibike_id)

          user.update({
            email: @email,
            password: @password,
            first_name: first_name,
            last_name: last_name,
            short_name: "#{first_name} #{last_name[0]}."
          })

          return user
        end
      end

    end
  end
end