Sequel.migration do
  up do
    add_column :routes, :distance, Integer
    add_column :routes, :map_thumb, String
    add_column :routes, :map_small, String
    add_column :routes, :map_large, String
  end

  down do
    drop_column :routes, :distance
    drop_column :routes, :map_thumb
    drop_column :routes, :map_small
    drop_column :routes, :map_large
  end
end
