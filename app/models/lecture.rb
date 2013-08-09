class Lecture < ActiveRecord::Base
  belongs_to :course
  attr_accessible :date, :description, :name, :room
end
