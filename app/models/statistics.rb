module CitiDash
  module Models
    class Statistics < Sequel::Model(:statistics)
      many_to_one :user
    end
  end
end