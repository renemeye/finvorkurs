class Question < ActiveRecord::Base
  belongs_to :vorkurs_test
  has_many :answers
  attr_accessible :text, :vorkurs_test_id, :false_answer_explanation

  def previous
    self.class.last :order => 'id', :conditions => ['id < ?', self.id]
  end

  def next
    self.class.first :order => 'id', :conditions => ['id > ?', self.id]
  end

  def answered_by? user
  	user.answers.each do |answer|
  		return true if answer.question_id == self.question_id
  	end
  	return false
  end

  def correct_answer_from? user
  	correct = true
  	answered_the_question = false

  	user.answers.each do |answer|
  		if answer.question_id == self.id
  			answered_the_question = true
  			correct = false unless answer.correct
  		end
  	end
  	return answered_the_question && correct
  end
end
