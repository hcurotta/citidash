module CitiDash
  module Services
    class Authenticator
      attr_reader :agent

      def initialize(email, password)
        @email = email.downcase
        @password = password
      end

      def self.get_authenticated_agent(user)
        authenticator = new(user.email, user.password)
        return authenticator.agent if authenticator.login
      end

      def login
        @agent = Mechanize.new
        page = @agent.get('https://member.citibikenyc.com/profile/login')
        form = page.form_with(action: 'https://member.citibikenyc.com/profile/login_check')
        form['_username'] = @email
        form['_password'] = @password
        page = form.submit
        page.uri.to_s == 'https://member.citibikenyc.com/profile/'
      end

      def register(accepts_terms)
        return nil unless accepts_terms && login
        user = User.find_or_create(
          citibike_id: citibike_account_details[:citibike_id]
        )
        user.set(email: @email,
                 first_name: citibike_account_details[:first_name],
                 last_name: citibike_account_details[:last_name],
                 short_name: "#{citibike_account_details[:first_name]} #{citibike_account_details[:last_name][0]}.",
                 terms_accepted_at: Time.now)

        user.password = @password
        user.save

        user
      end

      def authenticate_user
        return nil unless login

        user = User.find(citibike_id: citibike_account_details[:citibike_id])
        return nil unless user

        user.set(email: @email,
                 first_name: citibike_account_details[:first_name],
                 last_name: citibike_account_details[:last_name],
                 short_name: "#{citibike_account_details[:first_name]} #{citibike_account_details[:last_name][0]}.")

        user.password = @password
        user.save
        user
      end

      def citibike_account_details
        @citibike_user_details ||= {
          citibike_id: @agent.page.link_with(dom_class: 'ed-profile-page__link ed-profile-page__link_btn ed-profile-page__link_modify-member').href.split('/')[3],
          first_name: @agent.page.search('div.ed-panel__info__value_firstname').text,
          last_name: @agent.page.search('div.ed-panel__info__value_lastname').text
        }
      end
    end
  end
end
