class AddRemindedAtToDeclarations < ActiveRecord::Migration[8.1]
  def change
    add_column :declarations, :reminded_at, :datetime
  end
end
