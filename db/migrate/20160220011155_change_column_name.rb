class ChangeColumnName < ActiveRecord::Migration
  def change
	rename_column :asks, :from, 'integer USING CAST("column_to_change" AS integer)'
  end
end
