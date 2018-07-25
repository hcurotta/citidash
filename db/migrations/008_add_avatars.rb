Sequel.migration do
  up do
    create_table(:avatars) do
      primary_key :id
      String :url
    end

    add_column :users, :avatar_id, Integer
  end

  down do
    drop_table(:avatars)
  end
end
