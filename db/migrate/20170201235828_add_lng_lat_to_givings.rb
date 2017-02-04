class AddLngLatToGivings < ActiveRecord::Migration
  def change
    add_column :givings, :lng, :decimal
    add_column :givings, :lat, :decimal
  end
end
