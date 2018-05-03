Sequel.migration do
  up do
    create_table(:friendships) do
      primary_key :id
      Integer :user_id
      Integer :friend_id
      String  :status
    end
  end

  down do
    drop_table(:friendships)
  end
end