class PasswordResetsController < ApplicationController
  before_action :take_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)
  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "controllers.password_resets_controller.info"
      redirect_to root_url
    else
      flash.now[:danger] = t "controllers.password_resets_controller.notfound"
      render "new"
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add(:password, (t "controllers.password_resets_controller.notempty"))
      render "edit"
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = t "controllers.password_resets_controller.success"
      redirect_to @user
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def take_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    return unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return if @user.password_reset_expired?
    flash[:danger] = t "controllers.password_resets_controller.danger"
    redirect_to new_password_reset_url
  end
end
