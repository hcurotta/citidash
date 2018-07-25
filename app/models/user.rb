require 'openssl'

module CitiDash
  module Models
    class User < Sequel::Model(:users)
      attr_writer :password
      one_to_one :statistics
      one_to_many :routes
      one_to_many :trips
      one_to_many :notifications
      one_to_many :friendships
      many_to_one :avatar

      many_to_many :friends, left_key: :user_id, right_key: :friend_id, join_table: :friendships, class: :User do |dataset|
        dataset.where(status: 'accepted')
      end

      def before_create
        self.avatar_id = Avatar.first.id
      end

      def before_save
        if @password
          cipher = OpenSSL::Cipher::AES256.new :CBC
          cipher.encrypt
          cipher.key = ENV['DB_ENCRYPT_KEY']
          iv = cipher.random_iv
          cipher_text = cipher.update(@password) + cipher.final
          # Ensure UTF-8 for postgres
          self.encrypted_password = Base64.encode64(cipher_text).encode('utf-8')
          self.password_iv = Base64.encode64(iv).encode('utf-8')
        end
      end

      def password
        cipher_text = Base64.decode64(encrypted_password.encode('ascii-8bit'))
        decipher = OpenSSL::Cipher::AES256.new :CBC
        decipher.decrypt
        decipher.iv = Base64.decode64(password_iv.encode('ascii-8bit'))
        decipher.key = ENV['DB_ENCRYPT_KEY']
        decipher.update(cipher_text) + decipher.final
      end

      def jwt
        payload = {

          user: {
            id: id,
            exp: Time.now.to_i + 60 * 60,
            iat: Time.now.to_i
          }
        }

        JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
      end

      def refresh_data!
        agent = Authenticator.get_authenticated_agent(self)
        StatsScraper.new(self).scrape_stats(agent)
        TripScraper.new(self).scrape_trips(agent)
      end

      def to_api(nested_objects = {})
        {
          id: id,
          first_name: first_name,
          last_name: last_name,
          name: short_name
        }.merge(nested_objects)
      end
    end
  end
end
