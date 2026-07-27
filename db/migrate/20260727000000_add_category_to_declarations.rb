class AddCategoryToDeclarations < ActiveRecord::Migration[8.1]
  def change
    add_column :declarations, :category, :integer, default: 5, null: false
  end
end
