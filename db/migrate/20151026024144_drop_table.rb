class DropTable < ActiveRecord::Migration
  def change
  	drop_table :givings
  end
end
