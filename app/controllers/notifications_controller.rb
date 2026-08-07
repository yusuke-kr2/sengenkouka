class NotificationsController < ApplicationController
  layout "authenticated"
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.includes(actor: { avatar_attachment: :blob }, declaration: {}).recent.limit(50)
    current_user.notifications.unread.update_all(read: true)
  end
end
