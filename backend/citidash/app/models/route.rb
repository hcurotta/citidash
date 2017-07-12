module CitiDash
  module Models
    class Route < Sequel::Model(:routes)
      many_to_one :origin, class: :Station
      many_to_one :destination, class: :Station
    end
  end
end