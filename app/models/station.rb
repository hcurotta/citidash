module CitiDash
  module Models
    class Station < Sequel::Model(:stations)
      one_to_many :originating_routes, class: :Route, key: :origin_id
      one_to_many :destination_routes, class: :Route, key: :destination_id
      one_to_many :originating_trips, class: :Trip, key: :origin_id
      one_to_many :destination_trips, class: :Trip, key: :destination_id
    end
  end
end
