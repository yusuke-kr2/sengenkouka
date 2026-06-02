class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @declarations = @user.declarations.recent
    @declaring = @declarations.declaring
    @pending = @declarations.pending
    @completed = @declarations.completed
    judged = @pending.count + @completed.count
    @completion_rate = judged > 0 ? (@completed.count * 100 / judged) : 0
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
