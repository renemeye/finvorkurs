class ChangeQuestionsQuestionTypeFromStringToInteger < ActiveRecord::Migration
  def up
		change_table :questions do |t|
			t.change :question_type, :integer
		end
  end

  def down
		change_table :questions do |t|
			t.change :question_type, :string
		end
  end
end
