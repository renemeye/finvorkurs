class QuestionsController < ApplicationController
before_filter :authenticate_user!
before_filter :authenticate_admin!, except: :show

  def show
    @question = Question.find params[:id]
    @answers = []

    if Settings.vorkurs_test.randomized_questioning
      answer_count = @question.answers.count
      answers_to_show_count = [answer_count, Settings.vorkurs_test.max_answers_per_question].min
      answers_order = current_user.static_randoms(@question.id, answer_count*answer_count, 0, answer_count-1, 0).uniq | Array(0..answer_count-1) #After pipe: Fill with missing Elements
      had_correct = false
      had_wrong = false

      answers_to_show_count.times do |counter|
        next_answer = @question.answers[answers_order[counter]]
        had_correct = true if next_answer.correct?
        had_wrong = true unless next_answer.correct?

        #If there is a wrong or a right missing
        if counter >= answers_to_show_count - 1
          if not had_wrong 
            next_answer = @question.answers.find_by_correct(false)
          elsif not had_correct
            next_answer = @question.answers.find_by_correct(true)
          end
        end
        @answers << next_answer
      end
    else
      @answers = @question.answers
    end

    @test = VorkursTest.find params[:vorkurs_test_id]
    @user = current_user
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
    #TODO: Make the starting-point random here
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
