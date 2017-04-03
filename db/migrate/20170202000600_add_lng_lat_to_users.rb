class AddLngLatToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lng, :decimal
    add_column :users, :lat, :decimal
  end
end
