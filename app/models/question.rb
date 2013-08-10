class Question < ActiveRecord::Base
  belongs_to :vorkurs_test
  has_many :answers
  attr_accessible :text, :vorkurs_test_id, :false_answer_explanation, :question_type, :answers_attributes
  accepts_nested_attributes_for :answers, allow_destroy: true

  #validates :question_type, :inclusion => TYPES


  @@options = [
    :autolink=>true, 
    :disable_indented_code_blocks=>true, 
    :strikethrough=>true,
    :underline=>true,
    :lax_spacing => true,
    :hard_wrap=>true
  ]
  @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(*@@options), *@@options)


  TYPES = {
    :mapping => 3,
    :multiselectNoWrong => 2,
    :multiselectAllCorrect => 1,
    :singleSelect => 0
  }

  TYPE_NAMES = {
    3 => "Mapping",
    2 => "Multiselect & Select no wrong",
    1 => "Multiselect & Select all Correct",
    0 => "Single Select"
  }

    #Define user? admin? tutor? method
  TYPES.each do |meth, code|
    define_method("#{meth}?") { self.question_type == code }
  end

  #Define user! admin! tutor! method
  TYPES.each do |meth, code|
    define_method("#{meth}!") { self.question_type = code }
  end

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

  def as_json(options={})
    super(
      :include => [:answers]
    )
  end

  def markdown_text
   @@markdown.render(self.text)
  end

  def markdown_false_answer_explanation
   @@markdown.render(self.false_answer_explanation)
  end

  def readable_type
    TYPE_NAMES[self.question_type]
  end

end
