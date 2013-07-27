class HomeController < ApplicationController
  def index
  	@static_text = StaticText.all;

  	unless Settings.mode == "preregistration"
  		@user = current_user
  	else
		@user = User.new
	end
  end
end
