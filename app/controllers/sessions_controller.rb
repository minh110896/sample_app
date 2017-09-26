class SessionsController < ApplicationController
  def new; end

  def remember_user
    user = User.find_by(email: params[:session][:email].downcase)
    log_in user
    params[:session][:remember_me] == Settings.session ? remember(user) : forget(user)
    redirect_back_or user
  end

  def activated
    user = User.find_by(email: params[:session][:email].downcase)
    if user.activated?
      remember_user
    else
      message  = t "controllers.sessions_controller.notactivated"
      message += t "controllers.sessions_controller.check_email"
      flash[:warning] = message
      redirect_to root_url
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      activated
    else
      flash.now[:danger] = t "controllers.sessions_controller.warn"
      render "static_pages/home"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
