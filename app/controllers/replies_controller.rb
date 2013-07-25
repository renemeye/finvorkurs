class RepliesController < ApplicationController

  def create
    user = current_user
    answer = Answer.find params[:answer_id]
    question = answer.question
    user.answers << answer
    flash[:error] = "Deine letzte Antwort war leider falsch. Richtig ist XYZ, weil: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Repellendus, suscipit, accusantium, sequi ex delectus ipsa temporibus eveniet distinctio fuga incidunt magnam iusto provident inventore animi laboriosam quo harum eos dolorem?"
    redirect_to (question.test.resume_test_path(user) || test_path(question.test_id))
  end

end
