class RepliesController < ApplicationController

  def create
    user = current_user
    answer = Answer.find params[:answer_id]
    question = answer.question
    user.answers << answer
    redirect_to (question.test.resume_test_path(user) || test_path(question.test_id))
  end

end
