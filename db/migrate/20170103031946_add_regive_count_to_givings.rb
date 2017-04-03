class AddRegiveCountToGivings < ActiveRecord::Migration
  def change
    add_column :givings, :regive_count, :integer
  end
end
