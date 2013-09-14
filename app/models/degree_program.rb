class DegreeProgram < ActiveRecord::Base
  #has_and_belongs_to_many :newsletters
  has_many :newsletter_maps, :as => :receiver_group
  has_many :newsletters, :through => :newsletter_maps

  belongs_to :faculty
	has_and_belongs_to_many :users
  attr_accessible :name, :faculty_id, :degree, :his_id

	def name_and_degree
		return "#{self.name} (#{self.degree})"
	end

end
