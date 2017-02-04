class RemoveLngLatFromGivings < ActiveRecord::Migration
  def change
  	remove_column :givings, :lng, :decimal
    remove_column :givings, :lat, :decimal
  end
end
