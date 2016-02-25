class ChangeColumnName < ActiveRecord::Migration
  def change
	rename_column :asks, :from, 'integer USING CAST("user_id" AS integer)'
  end
end
