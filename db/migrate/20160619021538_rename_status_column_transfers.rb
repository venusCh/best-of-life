class RenameStatusColumnTransfers < ActiveRecord::Migration
  def change
  	rename_column :transfers, :status, :is_active
  end
end
