class AddUserIdToGiving < ActiveRecord::Migration
  def change
    add_column :givings, :user_id, :integer
  end
end
