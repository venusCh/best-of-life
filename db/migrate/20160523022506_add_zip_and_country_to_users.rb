class AddZipAndCountryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zip, :integer
    add_column :users, :country, :string
  end
end
