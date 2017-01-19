class AddCurrentHolderToGivings < ActiveRecord::Migration
  def change
    add_column :givings, :current_holder, :integer
  end
end
