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
	
end


# require 'test_helper'

# class UserTest < ActiveSupport::TestCase
#    test "pre registered User with E-Mail only" do
# 		 preRegisteredUser = User.new
# 		 preRegisteredUser.preregistered!
# 		 preRegisteredUser.email = "test@foo.bar"
#      assert preRegisteredUser.save
#    end

# 	test "User with unvalid E-Mail-Adress" do
# 		 preRegisteredUser = User.new
# 		 preRegisteredUser.email = "testfoo.bar"
# 		 preRegisteredUser.password = "123"
#      assert preRegisteredUser.invalid?
#    end

# 	 test "change user Role with all possible Roles" do
# 		 t = User.first;
# 		 t.preregistered!
# 		 assert t.preregistered?, "Should be preregisterd, but isn't"
# 		 assert_equal t.role, User::ROLES[:preregistered], "A preregistered is not a preregistered"
# 		 assert !t.admin?, "Is admin, but should be preregisterd"

# 		 t.registered!
# 		 assert t.registered?, "Should be registered, but isn't"
# 		 assert_equal t.role, User::ROLES[:registered], "A registered is not a registered"
# 		 assert !t.admin?, "Is admin, but should be registerd"

# 		 t.tutor!
# 		 assert t.tutor?, "Should be tutor, but isn't"
# 		 assert_equal t.role, User::ROLES[:tutor], "A tutor is not a tutor"
# 		 assert !t.admin?, "Is admin, but should be tutor"

# 		 t.admin!
# 		 assert t.admin?
# 		 assert_equal t.role, User::ROLES[:admin]
# 	 end

# 	test "creating any non preregistered user should not be possible without password" do
# 		 registeredUser = User.new
# 		 registeredUser.registered!
# 		 registeredUser.email = "testing@foo.bar"
#      assert registeredUser.invalid?, "A Registered user seems to be valid without password"
		 
# 		 registeredUser.password = "123"
# 		 assert registeredUser.save, "A Registered user with password is not saveable"

# 	end

# 	test "changing role from preregisted to registered needs insertion of password" do
# 		 preRegisteredUser = User.new
# 		 preRegisteredUser.preregistered!
# 		 preRegisteredUser.email = "testanother@foo.bar"
#      assert preRegisteredUser.save


# 		# pre --> reg don't work without passwort
# 		 preRegisteredUser.registered!
# 		 assert preRegisteredUser.invalid?, "A registered User without password is valid ... not good"


# 		# works with password
# 		preRegisteredUser.password = "123"
# 		assert preRegisteredUser.save, "A registered user with password is not saveable"
# 	end



# end
