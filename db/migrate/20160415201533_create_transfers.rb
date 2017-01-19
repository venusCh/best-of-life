class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :from
      t.integer :to
      t.references :giving, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
