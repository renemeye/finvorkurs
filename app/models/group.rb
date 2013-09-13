# encoding: utf-8
class Group < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  has_many :enrollments
  has_many :users, through: :enrollments
  accepts_nested_attributes_for :users

  has_many :degree_programs, through: :users, uniq: true
  has_many :faculties, through: :degree_programs, uniq: true
  
  attr_accessible :group_information, :room, :user_id, :course_id, :enrollment_ids

  @@markdown_options = [
    :autolink=>true, 
    :disable_indented_code_blocks=>true, 
    :no_intra_emphasis=>true,
    :strikethrough=>true,
    :underline=>true,
    :lax_spacing => true,
    :hard_wrap=>true
  ]
  @@markdown = Redcarpet::Markdown.new(MathjaxCompatibleMarkdown.new(*@@markdown_options), *@@markdown_options)

  
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

  def markdown_group_information
    return "" if self.group_information.nil?
    @@markdown.render(self.group_information)
  end

  def readable_group_scope
    scope = self.group_scope
    if scope.nil?
      return "Keine Studiengänge"
    elsif scope.is_a? DegreeProgram
      return "#{scope.degree} #{scope.name} (#{scope.faculty.short_name})"
    elsif scope.is_a? Faculty
      return "#{scope.short_name}"
    elsif scope.is_a? Array
      faculty_names = scope.collect{|f|f.short_name}
      return "Gemischt (#{faculty_names.join(", ")})"
    end
  end

  def group_scope
    degree_programs = self.degree_programs

    if degree_programs.count == 0
      return nil
    elsif degree_programs.count == 1
      return degree_programs.first
    else
      faculties = self.faculties
      if faculties.count == 1
        return faculties.first
      else
        return faculties
      end
    end
  end
end
