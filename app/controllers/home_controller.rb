class HomeController < ApplicationController
  def index
	   @current_user = current_user

  	unless Settings.mode == "preregistration"
      @user = current_user
  	else
		  @user = User.new
    end
    @courses = Course.all.group_by{|course| course.course_level}

    @recomended_courses = Recomendation.for_user(@current_user).group_by{ |c| c.course_level}

  end
end
