class CreateDeclarations < ActiveRecord::Migration[8.1]
  def change
    create_table :declarations do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.date :deadline, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
