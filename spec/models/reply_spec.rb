require 'spec_helper'

describe Reply do
	it "should be correct if it is the only correct at single select" do
		user = create(:user)
		question = create(:question_with_odd_correct_answers, question_type: Question::TYPES[:singleSelect])

		#correct ones
		answer = question.answers[0]
		Reply.create!(user: user, answer: answer, voted_as_correct: true)

		question.correct?(user.answers).should eq(true)
	end

	it "should be false if there is the only a false at single select" do
		user = create(:user)
		question = create(:question_with_odd_correct_answers, question_type: Question::TYPES[:singleSelect])

		#correct ones
		answer = question.answers[1]
		Reply.create!(user: user, answer: answer, voted_as_correct: true)

		question.correct?(user.answers).should eq(false)
	end


	it "should be correct if there are only correct at noWrong" do
		user = create(:user)
		question = create(:question_with_odd_correct_answers, question_type: Question::TYPES[:multiselectNoWrong])

		#correct ones
		Reply.create!(user: user, answer: question.answers[0], voted_as_correct: true)
		Reply.create!(user: user, answer: question.answers[2], voted_as_correct: true)
		Reply.create!(user: user, answer: question.answers[4], voted_as_correct: true)

		#false ones
		Reply.create!(user: user, answer: question.answers[5], voted_as_correct: false)

		question.correct?(user.answers).should eq(true)
	end

	it "should be correct if there are some correct voted as correct at noWrong" do
		user = create(:user)
		question = create(:question_with_odd_correct_answers, question_type: Question::TYPES[:multiselectNoWrong])

		#correct ones
		Reply.create!(user: user, answer: question.answers[0], voted_as_correct: true)
		Reply.create!(user: user, answer: question.answers[2], voted_as_correct: true)
		Reply.create!(user: user, answer: question.answers[4], voted_as_correct: false)

		#false ones
		Reply.create!(user: user, answer: question.answers[5], voted_as_correct: false)

		question.correct?(user.answers).should eq(true)
	end

	it "should be false if there are some correct and some wrong at noWrong" do
		user = create(:user)
		question = create(:question_with_odd_correct_answers, question_type: Question::TYPES[:multiselectNoWrong])
		
		#correct ones
		Reply.create!(user: user, answer: question.answers[0], voted_as_correct: true)
		Reply.create!(user: user, answer: question.answers[2], voted_as_correct: true)

		#false ones
		Reply.create!(user: user, answer: question.answers[3], voted_as_correct: true)
		Reply.create!(user: user, answer: question.answers[5], voted_as_correct: false)

		question.correct?(user.answers).should eq(false)
	end

	it "should be false if there are only wrong at noWrong" do
		user = create(:user)
		question = create(:question_with_odd_correct_answers, question_type: Question::TYPES[:multiselectNoWrong])

		#correct ones
		Reply.create!(user: user, answer: question.answers[0], voted_as_correct: false)
		Reply.create!(user: user, answer: question.answers[2], voted_as_correct: false)

		#false ones
		Reply.create!(user: user, answer: question.answers[3], voted_as_correct: true)
		Reply.create!(user: user, answer: question.answers[5], voted_as_correct: true)

		question.correct?(user.answers).should eq(false)
	end

	it "should be correct if there are only correct and all of them at allCorrect" do
		user = create(:user)
		question = create(:question_with_odd_correct_answers, question_type: Question::TYPES[:multiselectAllCorrect])

		#correct ones
		Reply.create!(user: user, answer: question.answers[0], voted_as_correct: true)
		Reply.create!(user: user, answer: question.answers[2], voted_as_correct: true)
		Reply.create!(user: user, answer: question.answers[4], voted_as_correct: true)

		#false ones
		Reply.create!(user: user, answer: question.answers[5], voted_as_correct: false)

		question.correct?(user.answers).should eq(true)
	end

	it "should be false if all had been marked as correct at allCorrect" do
		user = create(:user)
		question = create(:question_with_odd_correct_answers, question_type: Question::TYPES[:multiselectAllCorrect])

		#correct ones
		Reply.create!(user: user, answer: question.answers[0], voted_as_correct: true)
		Reply.create!(user: user, answer: question.answers[2], voted_as_correct: true)
		Reply.create!(user: user, answer: question.answers[4], voted_as_correct: true)

		#false ones
		Reply.create!(user: user, answer: question.answers[5], voted_as_correct: true)

		question.correct?(user.answers).should eq(false)
	end


	it "should be false if there are some correct and some wrong at allCorrect" do
		user = create(:user)
		question = create(:question_with_odd_correct_answers, question_type: Question::TYPES[:multiselectAllCorrect])

		#correct ones
		Reply.create!(user: user, answer: question.answers[0], voted_as_correct: false)
		Reply.create!(user: user, answer: question.answers[2], voted_as_correct: true)

		#false ones
		Reply.create!(user: user, answer: question.answers[3], voted_as_correct: false)
		Reply.create!(user: user, answer: question.answers[5], voted_as_correct: true)

		question.correct?(user.answers).should eq(false)
	end

	it "should be false if there are only wrong at allCorrect" do
		user = create(:user)
		question = create(:question_with_odd_correct_answers, question_type: Question::TYPES[:multiselectAllCorrect])

		#correct ones
		Reply.create!(user: user, answer: question.answers[0], voted_as_correct: false)
		Reply.create!(user: user, answer: question.answers[2], voted_as_correct: false)

		#false ones
		Reply.create!(user: user, answer: question.answers[3], voted_as_correct: false)
		Reply.create!(user: user, answer: question.answers[5], voted_as_correct: false)

		question.correct?(user.answers).should eq(false)
	end

	it "should have tests for mapping" do
		pending "Tests for mapping"
	end

end