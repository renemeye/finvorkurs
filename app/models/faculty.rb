class Faculty < ActiveRecord::Base
	attr_accessible :name, :short_name, :degree_programs_attributes
	has_many :degree_programs
	has_many :users, :through => :degree_programs, :uniq => true
  	accepts_nested_attributes_for :degree_programs, allow_destroy: true
end
