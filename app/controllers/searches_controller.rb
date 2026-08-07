class SearchesController < ApplicationController
  layout "authenticated"
  before_action :authenticate_user!

  def index
    @query = params[:q].to_s.strip
    @users = if @query.present?
      User.where("name ILIKE ?", "%#{User.sanitize_sql_like(@query)}%").where.not(id: current_user.id).limit(20)
    else
      User.none
    end
  end

  def suggestions
    query = params[:q].to_s.strip
    users = if query.present?
      User.where("name ILIKE ?", "%#{User.sanitize_sql_like(query)}%").where.not(id: current_user.id).limit(5).pluck(:name)
    else
      []
    end
    render json: users
  end
end
