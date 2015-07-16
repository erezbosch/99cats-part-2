class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

  def current_user
    return @current_user if @current_user
    User.all.each do |user|
      unless user.session_tokens.where(token: session[:session_token]).blank?
        @current_user = user
        return @current_user
      end
    end
    nil
  end

  def login_user!(user)
    user.create_session_token!
    session[:session_token] = user.session_tokens.last.token
  end

  def redirect_if_logged_in
    redirect_to cats_url if current_user
  end

  def redirect_unless_logged_in
    redirect_to new_session_url unless current_user
  end

  helper_method :current_user
end
