 require 'development_mail_interceptor'

 if not(Rails.env.test?)
	 ActionMailer::Base.delivery_method = :smtp
	 ActionMailer::Base.smtp_settings = {
	   :address              => Settings.mail.smtp.server_address,
	   :port                 => Settings.mail.smtp.port,
	   :user_name            => Settings.mail.smtp.user_name,
	   :password             => Settings.mail.smtp.password,
	   :authentication       => :login,
	   :enable_starttls_auto => true
	 }
end

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
