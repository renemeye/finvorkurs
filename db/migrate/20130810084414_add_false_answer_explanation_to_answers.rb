class AddFalseAnswerExplanationToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :false_answer_explanation, :text
  end
end
