class UsersController < ApplicationController
  layout "authenticated"
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @declarations = @user.declarations.includes(:witnesses).recent.to_a
    @declaring = @declarations.select { |d| d.declaring? && d.deadline >= Date.current }
    @pending = @declarations.select { |d| d.pending? || d.expired? }
    @completed = @declarations.select(&:completed?)
    judged = @pending.size + @completed.size
    @completion_rate = judged > 0 ? (@completed.size * 100 / judged) : 0
    @heatmap_data = build_heatmap_data(@user)
  end

  def followings
    @user = User.find(params[:id])
    @users = @user.followings.includes(avatar_attachment: :blob)
    @title = "フォロー中"
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers.includes(avatar_attachment: :blob)
    @title = "フォロワー"
  end
end
