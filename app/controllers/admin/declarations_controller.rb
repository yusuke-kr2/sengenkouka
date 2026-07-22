module Admin
  class DeclarationsController < BaseController
    def index
      @declarations = Declaration.includes(:user).order(created_at: :desc)
    end

    def destroy
      declaration = Declaration.find(params[:id])
      declaration.destroy
      redirect_to admin_declarations_path, notice: "宣言を削除しました"
    end
  end
end
