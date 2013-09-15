# encoding: UTF-8
require 'mathjax_compatible_markdown'

class Course < ActiveRecord::Base
  has_many :enrollments
  has_many :users, through: :enrollments
  has_many :lectures
  has_many :groups
  has_many :users_with_group, :through => :groups, :source => :users

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

  def course_name
  	return (self.course_level == self.title)?
  		self.title :
  		"#{self.course_level} \"#{self.title}\""
  end

  def self.course_levels
  	return Course.select(:course_level).uniq.collect{|c|c.course_level}
  end

  def self.by_level
    return Course.all.group_by{|c|c.course_level}
  end

  def markdown_description
    @@markdown.render(self.description)
  end

  def get_users_grouped_by_faculty_and_programs
    degreeProgram_users = self.users.group_by{|u| (u.degree_programs.count==0) ? 0 : u.degree_programs.first}

    faculty_degree_programs = Hash.new();
    degreeProgram_users.each do |program_id, users|
      faculty = (program_id == 0) ? 0 : DegreeProgram.find(program_id).faculty

      if faculty_degree_programs[faculty].nil?
        faculty_degree_programs[faculty] = {program_id => users }
      else
        faculty_degree_programs[faculty].merge!({program_id => users })
      end
    end

    return faculty_degree_programs
  end

  def users_without_group
    self.users.where("users.id NOT IN (#{self.users_with_group.select("users.id").to_sql})")
  end

end