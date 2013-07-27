class VorkursTest < ActiveRecord::Base
   attr_accessible :name, :description

   has_many :answers, through: :questions
   has_many :questions
   has_many :test_results

   def resume_test_path user
    next_question = (self.questions - user.questions).first
    next_question && [self, next_question]
  end
end
