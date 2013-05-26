class Faculty < ActiveRecord::Base
  attr_accessible :name, :short_name
	has_many :degree_programs
	has_many :users, :through => :degree_programs
end
