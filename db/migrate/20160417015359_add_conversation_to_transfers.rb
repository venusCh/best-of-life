class AddConversationToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :conversation, :integer
  end
end
