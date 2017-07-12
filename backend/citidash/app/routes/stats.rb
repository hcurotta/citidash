module CitiDash
  module Routes
    class Stats < Base
      use JwtAuth

      get '/stats' do
        Statistics.dataset.to_json
      end
    end
  end
end