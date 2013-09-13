class Group < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  has_many :enrollments
  has_many :users, through: :enrollments
  accepts_nested_attributes_for :users
  # attr_accessible :title, :body
  
  def to_s
    "#{self.course.title}: #{self.user.name}"
  end

  def self.initialize_groups_for_course course
  	user_per_group = (course.users.count*1.0/course.groups.count).ceil

  	faculty_programs_users = course.get_users_grouped_by_faculty_and_programs
  	groups = course.groups

  	groups_nr = 0

  	faculty_programs_users.each do |faculty, degreePrograms_users|
  		degreePrograms_users.each do |degreeProgram, users|
  			users.each do |user|
          #This shouldn't happen
  				raise "Too many users for these groups!" if groups[groups_nr].nil?
          
          enrollement = user.enrollments.where(:course_id => course.id).first
          enrollement.update_attribute(:group_id, groups[groups_nr].id)
          #Next group
  				groups_nr = groups_nr + 1 if groups[groups_nr].users.count >= user_per_group
  			end
  		end
  	end

  end
end
