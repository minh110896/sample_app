class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :load_user, only: %i(show update destroy)

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user
    flash[:danger] = t "controllers.users_controller.notload"
    redirect_to @user
  end

  def index
    @users = User.sort_by_name.paginate(page: params[:page])
  end

  def show
    return if @user
    flash[:danger] = t "controllers.users_controller.notfind"
    render "static_pages/home"
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "controllers.users_controller.success"
      redirect_to @user
    else
      render "new"
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t "controllers.users_controller.update"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    if load_user.destroy
      flash[:success] = t "controllers.users_controller.delete"
      redirect_to users_url
    else
      render "users/show"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controllers.users_controller.login"
    redirect_to login_url
  end

  def correct_user
    load_user
    redirect_to root_url unless current_user?(@user)
  end
end
