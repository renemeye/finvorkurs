class DegreeProgram < ActiveRecord::Base
  belongs_to :faculty
	has_and_belongs_to_many :users
  attr_accessible :name
end
