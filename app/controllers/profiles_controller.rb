class ProfilesController < ApplicationController
  layout "authenticated"
  before_action :authenticate_user!

  def show
    @declarations = current_user.declarations.recent.to_a
    @declaring = @declarations.select { |d| d.declaring? && d.deadline >= Date.current }
    @pending = @declarations.select { |d| d.pending? || d.expired? }
    @completed = @declarations.select(&:completed?)
    judged = @pending.size + @completed.size
    @completion_rate = judged > 0 ? (@completed.size * 100 / judged) : 0
    @heatmap_data = build_heatmap_data(current_user)
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
    params.require(:user).permit(:name, :bio, :avatar)
  end
end
