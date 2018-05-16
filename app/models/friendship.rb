module CitiDash
  module Models
    class Friendship < Sequel::Model(:friendships)
      plugin :validation_helpers

      many_to_one :user
      many_to_one :friend, class: :User, key: :friend_id

      # Validations

      def validate
        validates_unique([:user_id, :friend_id])
        super
      end

      # Callbacks

      def after_create
        # Create corresponding friendship (insert skips callbacks)
        update(status: 'requested')
        Friendship.insert(user_id: friend_id, friend_id: user_id, status: 'pending')
        super
      end

      def before_destroy
        # Destroy the corresponding friendship (delete skips callbacks)
        corresponding_friendship.delete
        super
      end

      def corresponding_friendship
        Friendship.find(user_id: friend_id, friend_id: user_id)
      end

      def accept!
        return false unless status == 'pending'
        update(status: 'accepted')
        corresponding_friendship.update(status: 'accepted')
      end
    end
  end
end
