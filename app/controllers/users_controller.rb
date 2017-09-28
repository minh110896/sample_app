class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :load_user, only: %i(show update destroy)

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user
    flash[:danger] = t "controllers.users_controller.notload"
    render "static_pages/home"
  end

  def index
    @users = User.sort_by_name.paginate(page: params[:page])
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
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
      @user.send_activation_email
      flash[:info] = t "controllers.users_controller.info"
      redirect_to root_url
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
    if User.find_by(id: params[:id]).destroy
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

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
