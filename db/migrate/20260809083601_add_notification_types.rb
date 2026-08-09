class AddNotificationTypes < ActiveRecord::Migration[8.1]
  def change
    change_column_null :notifications, :declaration_id, true
  end
end
