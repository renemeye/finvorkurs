class QuestionsController < ApplicationController
before_filter :authenticate_user!
before_filter :authenticate_admin!, except: :show

  def show
    @question = Question.find params[:id]
    @test = Test.find params[:vorkurs_test_id]
    @user = current_user
  end

  def new
    @question = Question.new
    @test = Test.find params[:vorkurs_test_id]
  end

  def create
    @test = Test.find params[:vorkurs_test_id]
    @question = Question.new params[:question]
    @test.questions << @question
    redirect_to [@test, @question], notice: "Frage erstellt"
  end

  def index
    #TODO: Make the starting-point random here
    @test = Test.find params[:vorkurs_test_id]
    @random_question = @test.questions.first
    redirect_to [@test, @random_question]
  end

end
