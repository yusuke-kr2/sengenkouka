class CreateWitnesses < ActiveRecord::Migration[8.1]
  def change
    create_table :witnesses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :declaration, null: false, foreign_key: true

      t.timestamps
    end
    add_index :witnesses, [ :user_id, :declaration_id ], unique: true
  end
end
