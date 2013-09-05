require 'spec_helper'

describe Recomendation do
	it "should be given for some courses" do
		user = create(:user)
		login_as user

		# One Course (1) for c_level 1
		course1 = create(:course, title: "c_level_1", course_level: "c_level_1")

		# Three Courses (2,3,4) for c_level 2
		course2 = create(:course, :title => "c_level_2", :course_level => "level_2")
		course3 = create(:course, :title => "c_level_3", :course_level => "level_2")
		course4 = create(:course, :title => "c_level_4", :course_level => "level_2")

		# One Courses (5) for c_level 3
		course5 = create(:course, title: "c_level_5", course_level: "c_level_5")

		#Both Tests with Questions and answers
		test1 = create(:vorkurs_test_with_questions)
		test2 = create(:vorkurs_test_with_questions)

		# A Test Level1	-> c_level_1 < 25% || c_level_5 < 75%
		Recomendation.create(min_percentage: 25, course_level: "c_level_1", vorkurs_test: test1)
		Recomendation.create(min_percentage: 75, course_level: "c_level_5", vorkurs_test: test1)

		# A Test Level2	-> c_level_2 < 75%
		Recomendation.create(min_percentage: 75, course_level: "level_2", vorkurs_test: test2)

		# Answer questions of Level1 (50% right)
		Reply.create(user: user, answer: test1.questions[0].answers[0], voted_as_correct: true)
		Reply.create(user: user, answer: test1.questions[1].answers[0], voted_as_correct: true)
		Reply.create(user: user, answer: test1.questions[2].answers[1], voted_as_correct: true)
		Reply.create(user: user, answer: test1.questions[3].answers[1], voted_as_correct: true)

		# Answer questions of Level2 (50% right)
		Reply.create(user: user, answer: test2.questions[0].answers[0], voted_as_correct: true)
		Reply.create(user: user, answer: test2.questions[1].answers[0], voted_as_correct: true)
		Reply.create(user: user, answer: test2.questions[2].answers[1], voted_as_correct: true)
		Reply.create(user: user, answer: test2.questions[3].answers[1], voted_as_correct: true)

		# Level1 should eq(50)%
		user.test_result(test1).should eq(50)

		# Level2 should eq(50)%
		user.test_result(test2).should eq(50)


		recs = Recomendation.for_user(user)

		recs.should_not include(course1)
		recs.should include(course2)
		recs.should include(course3)
		recs.should include(course4)
		recs.should include(course5)


		visit "/"
		#puts page.body
		page.should have_content("Nach Ihrem Testergebnis zu urteilen, empfehlen wir Ihnen, einen level_2 und den c_level_5 zu besuchen.")
							      
		#Recomendation.for_user(user).group_by{ |c| c.course_level}.each do |k,v|
		#	puts "Test: #{k} ||| Foo: #{v[0].title}"
		#end

	end

  	pending "Implement Recomendation Step 2"
end
