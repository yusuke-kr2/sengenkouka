class WitnessesController < ApplicationController
  before_action :authenticate_user!

  def create
    @declaration = Declaration.find(params[:declaration_id])
    current_user.witnesses.create(declaration: @declaration) unless @declaration.user == current_user
    redirect_back fallback_location: root_path
  end

  def destroy
    witness = current_user.witnesses.find(params[:id])
    witness.destroy
    redirect_back fallback_location: root_path
  end
end
