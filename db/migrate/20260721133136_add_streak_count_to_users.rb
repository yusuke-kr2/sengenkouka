class AddStreakCountToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :streak_count, :integer, default: 0, null: false
  end
end
