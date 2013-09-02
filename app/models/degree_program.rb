class DegreeProgram < ActiveRecord::Base
  has_and_belongs_to_many :newsletters
  belongs_to :faculty
	has_and_belongs_to_many :users
  attr_accessible :name, :faculty_id, :degree, :his_id

	def name_and_degree
		return "#{self.name} (#{self.degree})"
	end

end
