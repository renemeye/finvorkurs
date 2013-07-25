class TestsController < ApplicationController
before_filter :authenticate_user!

  def show
    @user = current_user
    @test = Test.find params[:id]
  end

  def new
    @user = current_user
    @test = Test.find params[:id]
  end

  def index
    @user = current_user
    @test = Test.find params[:id]
    correct = @user.answers_for(@test).reduce(0) { |a, e| a += e.correct ? 1 : 0 }
    @score = correct * 100 / @test.questions.count
    @test_result = @test.test_results.create
    @test_result.score = @score
    @user.test_results << @test_result
    Log.new(message: "#{@user.email} finished the test for #{@test.name} with #{@score}%").save
  end

end