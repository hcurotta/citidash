module CitiDash
  module Models
    class Friendship < Sequel::Model(:friendships)
      plugin :validation_helpers

      many_to_one :user
      many_to_one :friend, class: :User, key: :friend_id

      def validate
        validates_unique([:user_id, :friend_id])
        super
      end

      def after_create
        # Create corresponding friendship (insert skips callbacks)
        self.update(status: "requested")
        Friendship.insert(user_id: self.friend_id, friend_id: self.user_id, status: "pending")
        super
      end

      def before_destroy
        # Destroy the corresponding friendship (delete skips callbacks)
        self.corresponding_friendship.delete
        super
      end

      def corresponding_friendship
        Friendship.find(user_id: self.friend_id, friend_id: self.user_id)
      end

      def accept!
        if self.status == "pending"
          self.update(status: "accepted")
          self.corresponding_friendship.update(status: "accepted")
        end
      end
    end
  end
end