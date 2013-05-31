class DegreeProgram < ActiveRecord::Base
  belongs_to :faculty
	has_and_belongs_to_many :users
  attr_accessible :name

	def name_and_degree
		return "#{self.name} (#{self.degree})"
	end

end
