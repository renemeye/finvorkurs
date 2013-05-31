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
    !!current_user or redirect_to login_url, :notice => "Erst einloggen!"
  end

  def authenticate_admin!
    user = current_user and 
      user.admin? or 
        redirect_to login_url, :notice => "Nur für Admins!"
  end

  helper_method :current_user, :authenticate_user!
end
