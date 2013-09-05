class PreregisterLoginsController < ApplicationController

	def new
	end

	def create
		user = User.find_by_email(params[:email])
	    if user
	      user.send_preregistration_login_mail
	      redirect_to root_url, :notice => "E-Mail mit Anweisungen gesendet"
	    else
	      flash.now.alert = "Kein User mit dieser E-Mail-Adresse gefunden"
	      render :new
	    end
	end
end
