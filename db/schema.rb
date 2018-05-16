Sequel.migration do
  change do
    create_table(:routes) do
      primary_key :id
      Integer :origin_id
      Integer :destination_id
    end

    create_table(:schema_info) do
      Integer :version, default: 0, null: false
    end

    create_table(:stations) do
      primary_key :id
      Integer :citibike_station_id
      String :name, text: true
      BigDecimal :lat
      BigDecimal :lon
      TrueClass :inactive, default: false
    end

    create_table(:statistics) do
      primary_key :id
      Integer :user_id
      Integer :trip_count
      Integer :total_duration_in_seconds
      Integer :distance_travelled
    end

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

    create_table(:users) do
      primary_key :id
      String :email, text: true
      String :encrypted_password, text: true
      String :password_iv, text: true
      String :first_name, text: true
      String :last_name, text: true
      String :short_name, text: true
      String :citibike_id, text: true, null: false
    end
  end
end
