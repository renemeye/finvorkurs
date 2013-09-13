require 'spec_helper'

describe Enrollment do
	it "should be a good message with deleted user or course" do
		user1 = create(:user)
		course1 = create(:course)

		enrollment = Enrollment.create(user: user1, course: course1)
		enrollment.save

		enrollment.message.should_not eq(nil)

		enrollment.message.should include(user1.name)

		enrollment.message.should_not include("Deleted user")

		enrollment = Enrollment.create(user: nil, course: course1)

		enrollment.message.should include("Deleted user")

	end
end