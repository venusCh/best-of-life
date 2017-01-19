class AddStatusAndDueDateToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :status, :boolean
    add_column :transfers, :due_date, :datetime
  end
end
