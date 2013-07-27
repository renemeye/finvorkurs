# encoding: utf-8
class AnswersController < ApplicationController
before_filter :authenticate_admin!

  def create
    @answer = Answer.new params[:answer]
    @test = Test.find params[:vorkurs_test_id]
    @question = Question.find params[:question_id]
    if @question.answers << @answer
      redirect_to [@test, @question], notice: "Antwort hinzugefügt"
    end
  end
end
