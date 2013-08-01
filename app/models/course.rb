# encoding: UTF-8

class Course < ActiveRecord::Base
  has_many :enrollments
  has_many :users, through: :enrollments
  has_many :lectures

  def course_name
  	return (self.course_level == self.title)?
  		self.title :
  		"#{self.course_level} für #{self.title}"
  end

end