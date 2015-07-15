class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      user_params[:user_name],
      user_params[:password]
    )
    if @user
      login_user!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] = ["Incorrect login data"]
      render :new
    end
  end

  def destroy
    current_user.reset_session_token! if current_user
    session[:session_token] = nil
    redirect_to new_session_url
  end
end
