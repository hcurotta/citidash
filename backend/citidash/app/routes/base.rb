module CitiDash
  module Routes
    class Base < Sinatra::Application
      configure do
        set :root, App.root

        # disable :method_override
        # disable :protection

        # enable :use_code
      end

      helpers Helpers
    end
  end
end