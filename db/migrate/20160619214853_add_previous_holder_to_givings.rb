class AddPreviousHolderToGivings < ActiveRecord::Migration
  def change
    add_column :givings, :previous_holder, :integer
  end
end
