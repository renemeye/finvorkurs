# encoding: utf-8
class User < ActiveRecord::Base

  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :replies, dependent: :destroy
  has_many :answers, through: :replies, :select => :"answers.*, replies.voted_as_correct"
  has_many :questions, through: :answers
  has_many :test_results, dependent: :destroy
  has_many :groups, through: :enrollments
  has_and_belongs_to_many :degree_programs

  attr_accessible :email, :name, :password, :password_confirmation, :role, :group_ids, :degree_program_ids
  #validates :password, :presence => true, :on => :create, 
  validates :password_digest, presence: true, :unless => Proc.new { |user| user.preregistered? }
  validates :email, :uniqueness => true
  validates :email, format: {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, message: 'Ungültige E-Mail-Adresse'}
  validates :name, presence: true, :unless => proc { |u| u.courses.empty? }

  scope :without_degree_programs, where("users.id not in (SELECT user_id FROM degree_programs_users)")


	#self defined version of has_secure_password in order to have an :unless at the validations
	require 'bcrypt'
	attr_reader :password
	validates_confirmation_of :password, :unless => Proc.new { |user| user.preregistered?}
	validates_presence_of     :password_digest, :unless => Proc.new { |user| user.preregistered?}
	include InstanceMethodsOnActivation
	if respond_to?(:attributes_protected_by_default)
		def self.attributes_protected_by_default
			super + ['password_digest']
		end
	end
	# end self defined version of has_secure_password


	ROLES = {
		:admin => 3,
		:tutor => 2,
		:registered => 1,
		:preregistered => 0
	}	

  def generate_token column
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists? column => self[column]
  end

  def send_password_reset
    generate_token :password_reset_token
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def send_new_user_notification user
    UserMailer.new_user_notification(self, user).deliver
  end

	def send_email_confirmation_mail
		UserMailer.new_email_confirmation_mail(self).deliver
	end

  def send_newsletter post
    UserMailer.send_newsletter_to_user(self, post).deliver
  end

  def send_enrollment_confirmation course
    UserMailer.send_enrollment_confirmation_to_user(self, course).deliver
  end

  def in_course? course
    self.courses.include? course
  end

  def answers_for test
    self.answers.joins(:question).where(questions: {vorkurs_test_id: test})
  end

  def grouped_answers_for test
    answers = self.answers_for(test).order("replies.created_at")
    answers.group_by{ |answer| answer.question_id}
  end

  def completed_test? test
    test_questions = test.questions
    answered_questions = test_questions & self.questions
    max_needed = [test_questions.count, Settings.vorkurs_test.max_questions_per_test].min

    return answered_questions.count >= max_needed
  end

  def completed_all_tests?
    VorkursTest.all.each do |test|
      return false unless self.completed_test? test
    end
    return true
  end

  def started_test? test
    self.answers_for(test).count > 0
  end

  def test_result test
    groups = self.grouped_answers_for(test)
    return 0 if groups.count == 0
    correct_count = 0
    groups.each do |question_id, answer_group|
      question = Question.find(answer_group[0].question_id)
      correct_count+=1 if question.correct? answer_group
    end
    return correct_count*100/groups.count
  end

  def message
    "#{self.email} has created an Account"
  end

	#Define user? admin? tutor? method
	ROLES.each do |meth, code|
		define_method("#{meth}?") { self.role == code }
	end

	#Define user! admin! tutor! method
	ROLES.each do |meth, code|
		define_method("#{meth}!") { self.role = code }
	end

  # Returns a list of numbers wich seems to be random, but are static for a user
  # These nr's aren't stored, the are Created from the created_at atribute of each user
  # as the seed for a pseudo_random_nr generator
  # listNr -> Per user are different Random lists allowed. Each has the Nr listNr
  # count -> Nr of returned Randoms
  # min -> smallest nr returned
  # max -> Highest nr returned
  # round -> Nr of Digets round to. (false if no rounding is needed)
  def static_randoms listNr = 0, count = 100, min = 0, max = 1, round = false
    srand(self.created_at.to_i + listNr)
    values = []
    count.times do |counter|
      values[counter] = (rand()*(max-min))+min
      if round || round == 0
        values[counter] = values[counter].round(round)
      end
    end
    return values
  end

  # Returns a number wich seems to be random, but is static for a user
  # These nr's aren't stored, the are Created from the created_at atribute of each user
  # as the seed for a pseudo_random_nr generator
  # listNr -> Per user are different Random lists allowed. Each has the Nr listNr
  # count -> Nr of returned Randoms
  # min -> smallest nr returned
  # max -> Highest nr returned
  # round -> Nr of Digets round to. (false if no rounding is needed)
  def static_random listNr = 0, nr = 0, min = 0, max = 1, round = false
    srand(self.created_at.to_i + listNr)
    nr.times do |counter|
      rand()
    end
    val = (rand()*(max-min))+min
    if round || round == 0
      val = val.round(round)
    end
    return val
  end
end
