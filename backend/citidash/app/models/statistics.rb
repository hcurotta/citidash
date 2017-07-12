module CitiDash
  module Models
    class Statistics < Sequel::Model(:statistics)
      one_to_one :user
    end
  end
end