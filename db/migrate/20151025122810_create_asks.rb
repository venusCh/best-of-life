class CreateAsks < ActiveRecord::Migration
  def change
    create_table :asks do |t|
      t.integer :user_id
      t.text :comment
      t.references :giving, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
