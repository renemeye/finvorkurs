class HomeController < ApplicationController
  def index
  		@user = current_user
		#@user = User.new
  end
end
