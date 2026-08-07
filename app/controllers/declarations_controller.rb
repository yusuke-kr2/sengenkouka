class DeclarationsController < ApplicationController
  layout "authenticated"
  before_action :authenticate_user!

  def index
    @declarations = filter_by_category(filter_by_tag(filter_by_period(filter_by_scope(Declaration.includes(:witnesses, :tags, user: { avatar_attachment: :blob }).recent))))
    @declaration = Declaration.new(deadline: Date.today)
    @current_period = params[:period] || "all"
    @current_scope = params[:scope] || "all"
    @current_category = params[:category] || "all"
    @current_tag = params[:tag]
  end

  def create
    @declaration = current_user.declarations.build(declaration_params)
    if @declaration.save
      create_notifications_for_followers(@declaration)
      redirect_to root_path, notice: t("declarations.notices.created")
    else
      @declarations = filter_by_category(filter_by_tag(filter_by_period(filter_by_scope(Declaration.includes(:witnesses, :tags, user: { avatar_attachment: :blob }).recent))))
      @current_period = params[:period] || "all"
      @current_scope = params[:scope] || "all"
      flash.now[:alert] = @declaration.errors.full_messages.first
      render :index, status: :unprocessable_entity
    end
  end

  def complete
    @declaration = current_user.declarations.declaring.find(params[:id])
    @declaration.completed!
    current_user.increment_streak!
    redirect_to root_path, notice: t("declarations.notices.completed")
  end

  private

  def create_notifications_for_followers(declaration)
    current_user.followers.find_each do |follower|
      Notification.create!(user: follower, actor: current_user, declaration: declaration)
    end
  end

  def declaration_params
    params.require(:declaration).permit(:content, :deadline, :category, :tag_names)
  end

  def filter_by_scope(declarations)
    case params[:scope]
    when "following"
      following_ids = current_user.following_ids + [ current_user.id ]
      declarations.where(user_id: following_ids)
    else
      declarations
    end
  end

  def filter_by_category(declarations)
    if params[:category].present? && params[:category] != "all"
      declarations.where(category: params[:category])
    else
      declarations
    end
  end

  def filter_by_tag(declarations)
    if params[:tag].present?
      declarations.joins(:tags).where(tags: { name: params[:tag] })
    else
      declarations
    end
  end

  def filter_by_period(declarations)
    case params[:period]
    when "today"
      declarations.where(deadline: Date.today)
    when "this_week"
      declarations.where(deadline: Date.today..Date.today.end_of_week)
    when "this_month"
      declarations.where(deadline: Date.today..Date.today.end_of_month)
    when "later"
      declarations.where("deadline > ?", Date.today.end_of_month)
    else
      declarations
    end
  end
end
