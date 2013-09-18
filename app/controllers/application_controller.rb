# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
#  before_filter :visits_counter
 # force_ssl

  def visits_counter
    FNORD_METRIC.event _type: :visit, url: request.fullpath
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  private

  def current_user
		#TODO: Try to change this to params[:auth_token] on an new route ... just to avoid possible collision
    @current_user ||= User.find_by_preregistration_auth_token(params[:id]) if params[:id]
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
		return @current_user
  end

  def authenticate_user!
    unless !!current_user
      store_location
      redirect_to login_url, :notice => "Erst einloggen!"
      return false
    end
    return true
  end

  def authenticate_tutor!
    unless user = current_user and user.role >= User::ROLES[:tutor]
      store_location
      redirect_to login_url, :notice => "Nur für Dozenten!"
      return false
    end
    return true
  end

  def authenticate_admin!
    unless user = current_user and user.admin?
      store_location
      redirect_to login_url, :notice => "Nur für Admins!"
      return false
    end
    return true
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  helper_method :current_user, :authenticate_user!

  private 

    def clear_return_to
      session.delete(:return_to)
    end
end
