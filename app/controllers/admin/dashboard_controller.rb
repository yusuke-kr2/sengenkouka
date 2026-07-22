module Admin
  class DashboardController < BaseController
    def index
      @total_users = User.count
      @total_declarations = Declaration.count
      @total_completed = Declaration.completed.count
      @total_pending = Declaration.pending.count
      @total_declaring = Declaration.declaring.count
      @recent_users = User.order(created_at: :desc).limit(5)
      @recent_declarations = Declaration.includes(:user).order(created_at: :desc).limit(5)
    end
  end
end
