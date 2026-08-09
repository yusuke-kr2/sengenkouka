class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, class_name: "User"
  belongs_to :declaration, optional: true

  enum :notification_type, {
    follow: "follow",
    reminder: "reminder",
    followed: "followed",
    witnessed: "witnessed",
    declaration_completed: "declaration_completed"
  }

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }

  after_create_commit :broadcast_badge_update

  private

  def broadcast_badge_update
    [ "notification_badge_sidebar", "notification_badge_mobile" ].each do |target|
      Turbo::StreamsChannel.broadcast_replace_to(
        "notifications_#{user_id}",
        target: target,
        partial: "shared/notification_badge",
        locals: { user: user }
      )
    end
  end
end
