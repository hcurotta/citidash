Sequel.migration do
  up do
    create_table(:notifications) do
      primary_key :id
      Integer :user_id
      String  :body, text: true
      String  :type
      String  :associated_object_type
      Integer :associated_object_id
      TrueClass :read, default: false
      DateTime :updated_at
      DateTime :created_at
    end
  end

  down do
    drop_table(:notifications)
  end
end
