class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, class_name: "User"
  belongs_to :declaration

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }
end
