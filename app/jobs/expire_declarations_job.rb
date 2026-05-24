class ExpireDeclarationsJob < ApplicationJob
  queue_as :default

  def perform
    Declaration.declaring.where("deadline < ?", Date.today).update_all(status: :pending)
  end
end
