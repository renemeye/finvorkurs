# Coding: UTF-8

class UserMailer < ActionMailer::Base
  default from: Settings.mail.from

  def password_reset user
    @user = user
    mail :to => user.email, :subject => "Passwort zurücksetzen"
  end

  def new_user_notification admin, user
    @user = user
    mail to: admin.email, subject: "Neuer Account angelegt: #{user.email}"
  end

  def send_newsletter_to_user user, newsletter
    real_user = User.find(user.id)
    @user = real_user
    @content = newsletter.content

    mail to: @user.email, subject: "[OvGU Vorkurse] #{newsletter.subject}"
  end

  def send_enrollment_confirmation_to_user user, course
    @user = user
    @course = course
    mail to: user.email, subject: "[OvGU Vorkurse] Anmeldebestätigung #{course.title}"
  end

	def new_email_confirmation_mail user
		@user = user
		mail to: user.email, subject: "[OvGU Vorkurse] Bestätigung der E-Mail-Adresse"
	end

  def send_preregistration_login_mail user
    @user = user
    mail to: user.email, subject: "[OvGU Vorkurse] Link zum Login"
  end

end
