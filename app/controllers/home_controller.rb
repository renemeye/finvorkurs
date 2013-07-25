class HomeController < ApplicationController
  def index
  	unless Settings.mode == "preregistration"
  		@user = current_user
  	else
		@user = User.new
	end
  end
end
