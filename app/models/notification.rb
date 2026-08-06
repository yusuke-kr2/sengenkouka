class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, class_name: "User"
  belongs_to :declaration

  enum :notification_type, { follow: "follow", reminder: "reminder" }

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }
end
