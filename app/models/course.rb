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

  def self.course_levels
  	return Course.select(:course_level).uniq.collect{|c|c.course_level}
  end

  def self.by_level
    return Course.all.group_by{|c|c.course_level}
  end

end