class AddLngLatToGivings < ActiveRecord::Migration
  def change
    add_column :givings, :lng, :number
    add_column :givings, :lat, :number
  end
end
