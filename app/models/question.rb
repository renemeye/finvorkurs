class Question < ActiveRecord::Base
  belongs_to :vorkurs_test
  has_many :answers
  attr_accessible :text, :vorkurs_test_id, :false_answer_explanation, :question_type

  validates :question_type, :inclusion => %w(singleSelect multiselectAllCorrect multiselectNoWrong )

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

  def correct? users_answers_set
    correct = true

    if self.question_type == "singleSelect"
      return false
    elsif self.question_type == "multiselectAllCorrect"
      self.answers.each do |answer|
        return false unless answer.correct == users_answers_set.include?(answer)
      end
    elsif self.question_type == "multiselectNoWrong"
      self.answers.each do |answer|
        return false if ((not answer.correct) && users_answers_set.include?(answer))
      end
    end

    return correct
  end
end
