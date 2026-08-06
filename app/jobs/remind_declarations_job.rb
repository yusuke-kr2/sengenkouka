class RemindDeclarationsJob < ApplicationJob
  queue_as :default

  def perform
    Declaration.declaring
               .where(deadline: Date.tomorrow)
               .where(reminded_at: nil)
               .each do |declaration|
      Notification.create!(
        user: declaration.user,
        actor: declaration.user,
        declaration: declaration,
        notification_type: :reminder
      )
      declaration.update_column(:reminded_at, Time.current)
    end
  end
end
