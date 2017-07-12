module CitiDash
  module Routes
    class Authentication < Base

      post '/login' do
        authenticator = Authenticator.new(params[:email], params[:password])
        user = authenticator.authenticate_user
        if user 
          user.jwt
        else 
          halt 401
        end
      end
      
    end
  end
end