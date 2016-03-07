class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    @current_user ||= begin
      id = session[:user_id] || cookies.signed[:user_id]
      User.find_by(id: id) if id
    end
  end

  def set_current_user(user)
    session[:user_id] = user.id
    cookies.signed[:user_id] = {value: user.id, expires: 1.year.from_now}
    @current_user = user
  end
end
