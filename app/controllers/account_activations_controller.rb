class AccountActivationsController < ApplicationController
  def find_user
    @user = User.find_by email: params[:email]
  end

  def validate_true
    find_user
    user.activate
    user.update_attributes(activated: true, activated_at: Time.zone.now)
    log_in user
    flash[:success] = t "controllers.account_activation_controller.success"
    redirect_to user
  end

  def edit
    find_user
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      validate_true
    else
      flash[:danger] = t "controllers.account_activation_controller.danger"
      redirect_to root_url
    end
  end
end
