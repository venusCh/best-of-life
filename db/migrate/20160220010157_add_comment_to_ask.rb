class AddCommentToAsk < ActiveRecord::Migration
  def change
    add_column :asks, :comment, :string
  end
end
