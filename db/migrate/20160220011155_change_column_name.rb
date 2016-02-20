class ChangeColumnName < ActiveRecord::Migration
  def change
  	rename_column :asks, :body, :comment

  end
end
