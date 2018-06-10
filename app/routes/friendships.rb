module CitiDash
  module Routes
    class Friendships < Base
      use JwtAuth

      # Create Friendship
      post '/friendships' do
        halt 400 unless params['user_id']
        halt 400 if params['user_id'].to_i == current_user.id

        friend = User.find(id: params['user_id'])
        halt 404 unless friend

        friendship = Friendship.find_or_create(user_id: current_user.id, friend_id: friend.id)

        {
          id: friendship.id,
          status: friendship.status,
          user: {
            id: friend.id,
            first_name: friend.first_name,
            last_name: friend.last_name,
            name: friend.short_name
          }
        }.to_json
      end

      # Accept Friendship Request
      put '/friendships/:id' do
        friendship = Friendship.where(id: params['id']).eager(:friend).first
        friendship.accept!
        friendship.reload
        friend = friendship.friend

        {
          id: friendship.id,
          status: friendship.status,
          user: {
            id: friend.id,
            first_name: friend.first_name,
            last_name: friend.last_name,
            name: friend.short_name
          }
        }.to_json
      end

      # Reject/Cancel Friendship
      delete '/friendships/:id' do
        friendship = Friendship.find(id: params['id'])
        halt 404 unless friendship
        friendship.destroy
        status 200
      end
    end
  end
end
