# encoding: UTF-8
require 'mathjax_compatible_markdown'

class Course < ActiveRecord::Base
  has_many :enrollments
  has_many :users, through: :enrollments
  has_many :lectures

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
  		"#{self.course_level} für #{self.title}"
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

end