class HomeController < ApplicationController
  def index
  	@static_text = StaticText.all;

  	unless Settings.mode == "preregistration"
  		@user = current_user
  	else
		@user = User.new
	end

	@courses = Course.all.group_by{|course| course.course_level}
  end
end
