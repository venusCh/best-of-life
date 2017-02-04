class RemoveLngLatFromGivings < ActiveRecord::Migration
  def change
  	remove_column :givings, :lng, :number
    remove_column :givings, :lat, :number
  end
end
