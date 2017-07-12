module CitiDash
  module Helpers
    def current_user
      user_token_attributes = request.env.values_at(:user)

      if user_token_attributes
        @user ||= User.find(id: user_token_attributes[0]["id"])
      else
        @user = nil
      end

      return @user
    end
  end
end