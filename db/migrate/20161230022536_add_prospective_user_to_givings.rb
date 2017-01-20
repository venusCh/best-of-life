class AddProspectiveUserToGivings < ActiveRecord::Migration
  def change
    add_column :givings, :prospective_user, :integer
  end
end
