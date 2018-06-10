module CitiDash
  module Routes
    class Notifications < Base
      use JwtAuth

      # List notifications
      get '/notifications' do
        notifications = Notification.where(user_id: current_user.id).order(Sequel.desc(:created_at))

        if params['read'].present?
          notifications = notifications.where(read: params['read'])
        end

        format_query_json_response(notifications, request) do |notifications|
          notifications.map do |notification|
            {
              id: notification.id,
              body: notification.body,
              associated_object_id: notification.associated_object_id,
              associated_object_type: notification.associated_object_type,
              read: notification.read,
              created_at: notification.created_at
            }
          end
        end
      end

      # Read Notification
      put '/notifications/:id' do
        notification = Notification.find(id: params['id'])
        notification.read!
        notification.reload

        {
          id: notification.id,
          body: notification.body,
          associated_object_id: notification.associated_object_id,
          associated_object_type: notification.associated_object_type,
          read: notification.read,
          created_at: notification.created_at
        }.to_json
      end
    end
  end
end
