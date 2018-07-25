module CitiDash
  module Models
    class Avatar < Sequel::Model(:avatars)
      many_to_one :user
    end
  end
end
