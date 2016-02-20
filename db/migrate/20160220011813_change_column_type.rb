class ChangeColumnType < ActiveRecord::Migration
  def change
  	change_column :asks, :user_id, :integer
  end
end
