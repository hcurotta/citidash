Sequel.migration do
  up do
    create_table(:statistics) do
      primary_key :id
      Integer :user_id
      Integer :trip_count
      Integer :total_duration_in_seconds
      Integer :distance_travelled
    end
  end

  down do
    drop_table(:statistics)
  end
end