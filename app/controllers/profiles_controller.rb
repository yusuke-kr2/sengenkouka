class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @declarations = current_user.declarations.recent
    @pending = @declarations.pending
    @completed = @declarations.completed
    @completion_rate = @declarations.any? ? (@completed.count * 100 / @declarations.count) : 0
  end

  def edit
  end

  def update
    if current_user.update(profile_params)
      redirect_to profile_path, notice: t("profiles.notices.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :bio)
  end
end
