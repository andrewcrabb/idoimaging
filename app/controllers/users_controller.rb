class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :authenticate_user!

  def index
    @users = User.all.page params[:page]
  end

  def show
    unless @user and current_user.id.to_i.eql?(params[:id].to_i)
      flash[:alert] = "You are not authorized to access this resource!"
      redirect_to root_path
    end
    @foo = "bar"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    users = User.where(id: params[:id])
    @user = users.first if users.count > 0
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit([:email, :role])
  end
end
