module CitiDash
  module Routes
    class Avatars < Base
      use JwtAuth

      get '/avatars' do
        avatars = Avatar.dataset
        format_query_json_response(avatars, request) do |avatars|
          avatars.map do |avatar|
            {
              id: avatar.id,
              url: avatar.url
            }
          end
        end
      end
    end
  end
end
