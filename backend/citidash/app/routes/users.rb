module CitiDash
  module Routes
    class Users < Base
      # error Models::NotFound do
      #   error 404
      # end

      get '/login' do
        require 'pry'
        binding.pry

      end

      get '/hola' do
      end
    end
  end
end