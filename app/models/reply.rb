class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer
  attr_accessible :user, :answer, :voted_as_correct
end
