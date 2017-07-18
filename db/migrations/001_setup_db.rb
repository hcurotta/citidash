Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :email
      String :encrypted_password
      String :password_iv
      String :first_name
      String :last_name
      String :short_name
      String :citibike_id, :null=>false
    end
  end

  down do
    drop_table(:users)
  end
end