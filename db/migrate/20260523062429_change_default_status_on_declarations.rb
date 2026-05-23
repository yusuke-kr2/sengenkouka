class ChangeDefaultStatusOnDeclarations < ActiveRecord::Migration[8.1]
  def change
    # declarationsテーブルのstatusカラムのデフォルト値をpendingからdeclaringに変更
    change_column_default :declarations, :status, from: 0, to: 2
  end
end
