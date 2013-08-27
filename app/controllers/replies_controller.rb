#encoding: utf-8
class RepliesController < ApplicationController

  def create
    user = current_user
    answer = Answer.find params[:answer_id]
    #user.answers << answer
    Reply.create!(user: user, answer: answer, voted_as_correct: true)
    redirect_to (answer.question.vorkurs_test.resume_test_path(user) || vorkurs_test_path(answer.question.vorkurs_test_id))
  end

  def create_multiple
  	user = current_user
  	question = Question.find params[:question_id]

  	if params[:answer_ids].nil?
  		redirect_to (question.vorkurs_test.resume_test_path(user) || vorkurs_test_path(question.vorkurs_test_id)), notice: "Sie müssen mindestens eine der Antworten abgeben."
  		return
  	else
        #WARNING: this should be used only here, because we expect, that the system don't change (now/deleted answers or Settings like maximum answers) to much in between
        question.answers_presented_to_user(user).each do |answer|
          Reply.create!(user: user, answer: answer, voted_as_correct:(params[:answer_ids].include?(answer.id.to_s)))
      end
    end
    
  	redirect_to (question.vorkurs_test.resume_test_path(user) || vorkurs_test_path(question.vorkurs_test_id))
  end

end
