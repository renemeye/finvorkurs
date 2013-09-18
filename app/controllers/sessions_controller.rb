# Coding: UTF-8
class SessionsController < ApplicationController
	def new
	end

	def create
	  user = User.find_by_email(params[:email])
	  if user && user.preregistered?
		  redirect_to new_preregister_login_url(:email => user.email), :alert => "Ihr Account ist vorregistriert. Ihr login ist hier möglich."
		  return
	  end

	  if user && user.authenticate(params[:password])
	    session[:user_id] = user.id
		#redirect_to root_url
		flash[:notice] = "Login erfolgreich"
		redirect_back_or edit_user_path(user)
	  else
	    flash.now.alert = "Ungültige E-Mail oder Password"
	    render "new"
	  end
	end

	def destroy
	  session.delete :user_id
	  redirect_to root_url, :notice => "Logout erfolgreich"
	end
end
