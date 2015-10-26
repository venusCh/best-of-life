class CreateGivings < ActiveRecord::Migration
  def change
    create_table :givings do |t|
      t.string :name
      t.text :desc
      t.integer :user_id
      t.integer :wish
      t.integer :status

      t.timestamps null: false
    end
  end
end
