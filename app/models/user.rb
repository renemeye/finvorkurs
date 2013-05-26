# encoding: utf-8
class User < ActiveRecord::Base

  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :replies, dependent: :destroy
  has_many :answers, through: :replies
  has_many :questions, through: :answers
  has_many :test_results, dependent: :destroy
  has_many :groups, through: :enrollments

  attr_accessible :email, :name, :password, :password_confirmation, :role, :group_ids
  #validates :password, :presence => true, :on => :create, 
	validates :password_digest, presence: true, :unless => Proc.new { |user| user.preregistered? }
  validates :email, :uniqueness => true
  validates :email, format: {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, message: 'Ungültige E-Mail-Adresse'}
  validates :name, presence: true, :unless => proc { |u| u.courses.empty? }

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

  def send_newsletter post
    if self.present?
      UserMailer.send_newsletter_to_user(self, post).deliver
    end
  end

  def send_enrollment_confirmation course
    UserMailer.send_enrollment_confirmation_to_user(self, course).deliver
  end

  def in_course? course
    self.courses.include? course
  end

  def answers_for course
    self.answers.joins(:question).where questions: {course_id: course}
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

end
