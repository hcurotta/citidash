Sequel.migration do
  up do
    create_table(:trips) do
      primary_key :id
      Integer :user_id
      Integer :route_id
      Integer :origin_id
      Integer :destination_id
      DateTime :started_at
      DateTime :ended_at
      Integer :duration_in_seconds
    end

    create_table(:stations) do
      primary_key :id
      Integer :citibike_station_id
      String :name
      Decimal :lat
      Decimal :lon
      Boolean :inactive, default: false
    end

    create_table(:routes) do
      primary_key :id
      Integer :origin_id
      Integer :destination_id
    end

  end

  down do
    drop_table(:trips)
    drop_table(:stations)
    drop_table(:routes)
  end
end