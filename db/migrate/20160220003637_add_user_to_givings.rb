class AddUserToGivings < ActiveRecord::Migration
  def change
    add_reference :givings, :user, index: true, foreign_key: true
  end
end
