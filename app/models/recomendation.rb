class Recomendation < ActiveRecord::Base
  belongs_to :vorkurs_test
  attr_accessible :course_level, :min_percentage, :vorkurs_test

  def self.for_user user
  	return [] if user.nil?

  	recomended_courses = []
 	#Step1:
	# - Go through all Recomendations and list the recomended course_levels
	Recomendation.all.each do |recomendation|
		if recomendation.min_percentage > user.test_result(recomendation.vorkurs_test)
			recomended_courses += Course.find_all_by_course_level(recomendation.course_level)
		end
	end


	#Step2:
	# - Go trough all Courses and list the ones who are recomended in level and serves the faculty


	return recomended_courses.sort
  end
end
