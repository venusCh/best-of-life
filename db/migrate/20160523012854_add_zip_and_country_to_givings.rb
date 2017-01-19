class AddZipAndCountryToGivings < ActiveRecord::Migration
  def change
    add_column :givings, :zip, :integer
    add_column :givings, :country, :string
  end
end
