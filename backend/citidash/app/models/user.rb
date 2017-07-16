require 'openssl'

module CitiDash
  module Models
    class User < Sequel::Model(:users)
      attr_writer :password
      one_to_one :statistics
      one_to_many :routes
      one_to_many :trips

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
            iat: Time.now.to_i,
          }
        }

        JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
      end

      def refresh_data
        StatsScraper.new(self).load_stats
        TripScraper.new(self).load_trips
      end

    end
  end
end