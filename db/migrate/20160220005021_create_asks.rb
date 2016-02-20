class CreateAsks < ActiveRecord::Migration
  def change
    create_table :asks do |t|
      t.string :from
      t.text :body
      t.integer :status
      t.references :giving, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
