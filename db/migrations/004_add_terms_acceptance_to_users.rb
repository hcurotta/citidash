Sequel.migration do
  up do
    add_column :statistics, :last_trip_ended_at, DateTime
    add_column :users, :last_refreshed_at, DateTime
    add_column :users, :terms_accepted_at, DateTime
    from(:users).update(terms_accepted_at: Time.now)
  end

  down do
    drop_column :statistics, :last_trip_ended_at
    drop_column :users, :last_refreshed_at
    drop_column :users, :terms_accepted_at
  end
end