class RepliesController < ApplicationController

  def create
    user = current_user
    answer = Answer.find params[:answer_id]
    question = answer.question
    user.answers << answer
    redirect_to (question.vorkurs_test.resume_test_path(user) || vorkurs_test_path(question.vorkurs_test_id))
  end

  def create_multiple
  	user = current_user
  	question = Question.find params[:question_id]

  	if params[:answer_ids].nil?
  		redirect_to (question.vorkurs_test.resume_test_path(user) || vorkurs_test_path(question.vorkurs_test_id)), notice: "Du musst mindestens eine der Antworten abgeben. Die Frage wird nach hinten geschoben."
  		return
  	else
    	answers = Answer.find params[:answer_ids]
    	answers.each do |answer|
	    	user.answers << answer
	    end
    end
    
  	redirect_to (question.vorkurs_test.resume_test_path(user) || vorkurs_test_path(question.vorkurs_test_id))
  end

end
