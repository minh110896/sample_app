class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])

    unless @user
      flash[:danger] = t "controller.users_controller.notfind"
      render "static_pages/home"
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "controller.users_controller.success"
      redirect_to @user
    else
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
