module CitiDash
  module Models
    class Notification < Sequel::Model(:notifications)
      Sequel::Model.plugin :timestamps, :update_on_create => true 

      many_to_one :user

      def read!
        update(read: true)
      end
    end
  end
end