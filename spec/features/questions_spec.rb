# encoding: utf-8
require 'spec_helper'

describe Question do
	it "should not show question-overview for non admins" do
		user = create(:user)
		login_as user

		visit overview_questions_path
		page.should have_content("Nur für Admins")
	end

	it "should not show solution-overview for non admins" do
		user = create(:user)
		login_as user

		visit solutions_questions_path
		page.should have_content("Nur für Admins")		
	end

	it "shows all question in question-overview and solution-overview" do
		user = create(:admin)
		question = create(:question, :text => "Hallo Welt?")
		question2 = create(:question, :text => "Nichts anders?")
		login_as(user)

		visit overview_questions_path
		page.should have_content(question.text)
		page.should have_content(question2.text)

		visit solutions_questions_path
		page.should have_content(question.text)

	end

	it "shows all possible Answers for a question in question-overview" do
		user = create(:admin)
		question = create(:question, :text => "Hallo Welt?")
		question.answers << Answer.create(:text => "Antwort 1")
		question.answers << Answer.create(:text => "Antwort 2")
		question.answers << Answer.create(:text => "Antwort 3")
		question.answers << Answer.create(:text => "Antwort 4")
		question.answers << Answer.create(:text => "Antwort 5")
		question.answers << Answer.create(:text => "Antwort 6")
		login_as(user)

		visit overview_questions_path
		page.should have_content(question.text)
		page.should have_content("Antwort 1")
		page.should have_content("Antwort 2")
		page.should have_content("Antwort 3")
		page.should have_content("Antwort 4")
		page.should have_content("Antwort 5")
		page.should have_content("Antwort 6")

		visit solutions_questions_path
		page.should have_content(question.text)
		page.should have_content("Antwort 1")
		page.should have_content("Antwort 2")
		page.should have_content("Antwort 3")
		page.should have_content("Antwort 4")
		page.should have_content("Antwort 5")
		page.should have_content("Antwort 6")
	end

	it "does not remove escape signs in latex code for questions in asking" do
		user = create(:admin)
		login_as user
		latex_test_code = "\\mathbb{N} = \\{0, 1, 2, \\ldots \\}"
		#puts latex_test_code
		question = create(:question, :text => "Hallo `$#{latex_test_code}$` Welt?")

		visit overview_questions_path
		page.should have_content(latex_test_code)
	end

	it "does not remove escape signs in latex code for questions in solutions" do
		user = create(:admin)
		login_as user
		latex_test_code = "\\mathbb{N} = \\{0, 1, 2, \\ldots \\}"
		#puts latex_test_code
		question = create(:question, :text => "Hallo `$#{latex_test_code}$` Welt?")

		visit solutions_questions_path
		page.should have_content(latex_test_code)
	end

end