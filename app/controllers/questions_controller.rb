class QuestionsController < ApplicationController
before_filter :authenticate_user!
before_filter :authenticate_admin!, except: :show

  def show
    @question = Question.find params[:id]
    @test = VorkursTest.find params[:vorkurs_test_id]
    @user = current_user
    @answers = @question.answers_presented_to_user @user
    if(@answers.include? nil)
      redirect_to vorkurs_test_path(@test.id), :notice => "Diese Frage ist nicht darstellbar. Bitte wenden Sie sich an #{Settings.mail.from}."
    end
    if(@question.answered_by? @user)
      redirect_to vorkurs_test_path(@test.id), :notice => "Sie haben diese Frage bereits beantwortet."
    end
  end

  def new
    @question = Question.new
    @test = VorkursTest.find params[:vorkurs_test_id]
  end

  def create
    @test = VorkursTest.find params[:vorkurs_test_id]
    @question = Question.new params[:question]
    @test.questions << @question
    redirect_to [@test, @question], notice: "Frage erstellt"
  end

  def index
    @test = VorkursTest.find params[:vorkurs_test_id]
    @random_question = @test.questions.first
    redirect_to [@test, @random_question]
  end

  def overview
    @questions = Question.all
  end

  def solutions
    @questions = Question.all
  end

end
