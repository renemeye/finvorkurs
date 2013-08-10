class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :replies
  attr_accessible :correct, :text, :question_id, :false_answer_explanation
end
