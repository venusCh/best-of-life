class AddLngLatToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lng, :number
    add_column :users, :lat, :number
  end
end
