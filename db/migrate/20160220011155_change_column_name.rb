class ChangeColumnName < ActiveRecord::Migration
  def change
	rename_column :asks, :from, :user_id
  end
end
