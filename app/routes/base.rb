module CitiDash
  module Routes
    class Base < Sinatra::Application
      configure do
        set :root, App.root

        # disable :method_override
        # disable :protection

        # enable :use_code
      end

      before do
        content_type 'application/json'
      end

      helpers Helpers
    end
  end
end
