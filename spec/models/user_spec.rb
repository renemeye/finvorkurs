require 'spec_helper'

describe User do
	describe "#send_password_reset" do
		let(:user){create(:user)}

		it "generates a unique password_reset_token each time" do
			user.send_password_reset
			last_token = user.password_reset_token
			user.send_password_reset
			user.password_reset_token.should_not eq(last_token)
		end

		it "saves the time the password reset was sent" do
			user.send_password_reset
			user.reload.password_reset_sent_at.should be_present
		end

		it "delivers email to user" do
			user.send_password_reset
			last_email.to.should include(user.email)
		end

		it "sends only one email" do
			user.send_password_reset
			last_emails.count.should eq(1)
		end

		it "sends an email containing the reset_token" do
			user.send_password_reset
			last_email.body.should include(user.password_reset_token)
		end
	end

	describe "#send_password_reset_for_preregistered_users" do
		let(:user){create(:preregistered)}

		it "generates a unique password_reset_token each time" do
			user.send_password_reset
			last_token = user.password_reset_token
			user.send_password_reset
			user.password_reset_token.should_not eq(last_token)
		end

		it "saves the time the password reset was sent" do
			user.send_password_reset
			user.reload.password_reset_sent_at.should be_present
		end

		it "delivers email to user" do
			user.send_password_reset
			last_email.to.should include(user.email)
		end

		it "sends only one email" do
			user.send_password_reset
			last_emails.count.should eq(1)
		end

		it "sends an email containing the reset_token" do
			user.send_password_reset
			last_email.body.should include(user.password_reset_token)
		end
	end

	pending "Test for users send mail"
	
	
end