class AddFalseAnswerExplanationToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :false_answer_explanation, :text
  end
end
