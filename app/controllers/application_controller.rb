class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :set_cache_buster

  helper_method :current_user

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
  	redirect_to '/home/index' unless current_user
  end

  def check_user
    redirect_to '/dashboard' if current_user
  end

  private
    def set_cache_buster
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
end
