class DeclarationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @declarations = Declaration.includes(:user).recent
    @declaration = Declaration.new(deadline: Date.today)
  end

  def create
    @declaration = current_user.declarations.build(declaration_params)
    if @declaration.save
      redirect_to root_path, notice: t("declarations.notices.created")
    else
      @declarations = Declaration.includes(:user).recent
      flash.now[:alert] = @declaration.errors.full_messages.first
      render :index, status: :unprocessable_entity
    end
  end

  def complete
    @declaration = current_user.declarations.declaring.find(params[:id])
    @declaration.completed!
    redirect_to root_path, notice: t("declarations.notices.completed")
  end

  private

  def declaration_params
    params.require(:declaration).permit(:content, :deadline)
  end
end
