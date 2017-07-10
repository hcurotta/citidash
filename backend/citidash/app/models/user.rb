module CitiDash
  module Models
    class User < Sequel::Model(:users)

      def self.setup_user(email, password)
        existing_user = User.where(email: email).first
        
        if existing_user
          return existing_user
        else
          agent = Mechanize.new
          page = agent.get('https://member.citibikenyc.com/profile/login')
          form = page.form_with(action: 'https://member.citibikenyc.com/profile/login_check')
          form['_username'] = email
          form['_password'] = password
          page = form.submit

          first_name = page.search('div.ed-panel__info__value_firstname').text
          last_name = page.search('div.ed-panel__info__value_lastname').text
          modify_link = page.link_with(dom_class: "ed-profile-page__link ed-profile-page__link_btn ed-profile-page__link_modify-member").href
          citibike_id = modify_link.split('/')[3]

          user = self.create({
            email: email,
            password: password,
            first_name: first_name,
            last_name: last_name,
            citibike_id: citibike_id
          })

          return user
        end
      end
    end
  end
end