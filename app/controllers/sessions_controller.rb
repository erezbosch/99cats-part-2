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

  def destroy # log out!
    destroy_current_session_token! if current_user
    session[:session_token] = nil
    redirect_to new_session_url
  end

  private

  def destroy_current_session_token!
    current_session_token.destroy!
  end

  def current_session_token
    current_user.session_tokens.find_by(token: session[:session_token])
  end
end
