require 'mathjax_compatible_markdown'

class Question < ActiveRecord::Base
  belongs_to :vorkurs_test
  has_many :answers
  has_many :replies, :through => :answers
  has_many :users, :through => :replies, :uniq => true
  attr_accessible :text, :vorkurs_test_id, :false_answer_explanation, :question_type, :answers_attributes, :category
  accepts_nested_attributes_for :answers, allow_destroy: true

  #validates :question_type, :inclusion => TYPES


  @@markdown_options = [
    :autolink=>true, 
    :disable_indented_code_blocks=>true, 
    :no_intra_emphasis=>true,
    :strikethrough=>true,
    :underline=>true,
    :lax_spacing => true,
    :hard_wrap=>true
  ]
  @@markdown = Redcarpet::Markdown.new(MathjaxCompatibleMarkdown.new(*@@markdown_options), *@@markdown_options)


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

 # def previous
 #   self.class.last :order => 'id', :conditions => ['id < ?', self.id]
 # end

 # def next
 #   self.class.first :order => 'id', :conditions => ['id > ?', self.id]
 # end

  def answered_by? user
  	user.answers.each do |answer|
  		return true if answer.question_id == self.id
  	end
  	return false
  end

  def correct? users_answers_set
    correct = true

    if self.singleSelect?
      users_answers_set.each do |answer|
        return false if (not answer.correct) && (answer.voted_as_correct == 't')
      end

    elsif self.multiselectAllCorrect?
      users_answers_set.each do |answer|
        return false if answer.correct && (answer.voted_as_correct != 't')
        return false if (not answer.correct) && (answer.voted_as_correct == 't')
      end

    elsif self.multiselectNoWrong?
      users_answers_set.each do |answer|
        return false if (not answer.correct) && (answer.voted_as_correct == 't')
      end

    elsif self.mapping?
      users_answers_set.each do |answer|
        return false if (not answer.correct) && (answer.voted_as_correct == 't')
        return false if answer.correct && (answer.voted_as_correct != 't')
      end

    else
      puts "WARNING"
      return false

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

  def self.get_tex_scheme
      "
      % #####################
      % Schema ist wie folgt:
      % #####################
      % \\aufgabe{Level}{Kategorie}{Wie viele die gesehen haben}{Text}{falschhinweis (ggf leer)}
      % \\begin{antworten}
      %     \\antwort{true}{korrekte anworten}{falsche antworten}{Text}{falschhinweis (ggf leer)}
      %     \\antwort{false}{korrekte anworten}{falsche antworten}{Text}{falschhinweis (ggf leer)}
      % \\end{antworten}
      "
  end

  def get_tex_result
      question_tex = "\\aufgabe{#{self.vorkurs_test.name}}{#{self.category}}{#{self.users.count}}{#{self.text}}{#{self.false_answer_explanation}}"

      answers_tex = self.answers.collect do |answer| 
        answer_tex = "\\antwort{#{answer.correct}}{#{answer.replies.where(voted_as_correct: answer.correct).count}}{#{answer.replies.where(voted_as_correct: (not answer.correct)).count}}{#{answer.text}}{#{answer.false_answer_explanation}}"
        "
            #{answer_tex}
        "
      end

      "
      #{question_tex}
      \\begin{antworten}
        #{answers_tex.join }
      \\end{antworten}
      "
  end

  def self.categories vorkurs_test = nil
    categorized = {}
    if vorkurs_test
      Question.where(:vorkurs_test_id => vorkurs_test.id).order("id ASC").uniq.pluck(:category).each do |category|
        categorized[category] = Question.where(:vorkurs_test_id => vorkurs_test.id).order("id ASC").where(:category => category)
      end
    else
      return Question.uniq.order("id ASC").pluck(:category)
    end

    return categorized
  end

  #WARNING: THIS IS NOT LONG TIME STABLE. SO DON'T USE IT TO REFERENCE WETHER A USER GOT THESE ANSWERS OR NOT
  #LONG TIME MEANS HERE created or deleted answers or changed Settings like maximum answers per question
  def answers_presented_to_user user
    answers = []

    if Settings.vorkurs_test.randomized_questioning
      answer_count = self.answers.count
      answers_to_show_count = [answer_count, Settings.vorkurs_test.max_answers_per_question].min
      answers_order = user.static_randoms(self.id, answer_count*answer_count, 0, answer_count-1, 0).uniq | Array(0..answer_count-1) #After pipe: Fill with missing Elements
      had_correct = false
      had_wrong = false

      answers_to_show_count.times do |counter|
        next_answer = self.answers[answers_order[counter]]
        had_correct = true if next_answer.correct?
        had_wrong = true unless next_answer.correct?

        #If there is a wrong or a right missing
        if counter >= answers_to_show_count - 1
          if not had_wrong 
            next_answer = self.answers.find_by_correct(false)
          elsif not had_correct
            next_answer = self.answers.find_by_correct(true)
          end
        end
        answers << next_answer
      end
    else
      answers = @question.answers
    end
    return answers
  end

end
