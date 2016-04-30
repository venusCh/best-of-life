class AddLocationToGiving < ActiveRecord::Migration
  def change
    add_column :givings, :current_location, :string
  end
end
