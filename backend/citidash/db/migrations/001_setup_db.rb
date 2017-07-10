Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :email, :null=>false
      String :password, :null=>false
      String :first_name
      String :last_name
      String :citibike_id
    end
  end

  down do
    drop_table(:users)
  end
end