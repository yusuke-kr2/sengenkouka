class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @declarations = current_user.declarations.recent # ユーザーの全宣言を新しい順に取得
    @declaring = @declarations.declaring # 宣言中のものを抽出
    @pending = @declarations.pending # 未達成のものを抽出
    @completed = @declarations.completed # 達成のものを抽出
    judged = @pending.count + @completed.count # 未達成＋達成の合計件数（宣言中は省く）
    @completion_rate = judged > 0 ? (@completed.count * 100 / judged) : 0 # 率計算
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
