module CitiDash
  module Routes
    class Authentication < Base
      post '/register' do
        authenticator = Authenticator.new(params[:email], params[:password])
        user = authenticator.register(params[:accepts_terms])
        if user
          {
            auth_token: user.jwt,
            user: {
              id: user.id,
              name: user.short_name
            }
          }.to_json
        else
          halt 401
        end
      end

      post '/login' do
        authenticator = Authenticator.new(params[:email], params[:password])
        user = authenticator.authenticate_user
        if user
          {
            auth_token: user.jwt,
            user: {
              id: user.id,
              name: user.short_name
            }
          }.to_json
        else
          halt 401
        end
      end
    end
  end
end
