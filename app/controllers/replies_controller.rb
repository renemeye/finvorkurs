class RepliesController < ApplicationController

  def create
    user = current_user
    answer = Answer.find params[:answer_id]
    question = answer.question
    user.answers << answer
    redirect_to (question.vorkurs_test.resume_test_path(user) || vorkurs_test_path(question.vorkurs_test_id))
  end

end
