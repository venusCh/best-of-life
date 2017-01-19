class ChangeTransfersColumnNames < ActiveRecord::Migration
  def change
	rename_column :transfers, :from, :from_id
	rename_column :transfers, :to, :to_id
  end
end
