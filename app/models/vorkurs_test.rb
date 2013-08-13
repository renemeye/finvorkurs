class VorkursTest < ActiveRecord::Base
   attr_accessible :name, :description

   has_many :answers, through: :questions
   has_many :questions, order: :id
   has_many :test_results

   def resume_test_path user

   	if Settings.vorkurs_test.randomized_questioning
	   	test_questions = self.questions
	   	test_questions_count = self.questions.count
	   	answered_questions = test_questions & user.questions

	   	# Answered enough questions?
	   	max_needed = [test_questions_count, Settings.vorkurs_test.max_questions_per_test].min
		return false if answered_questions.count >= max_needed

		# Find the first unanswerd question
		static_random_order = user.static_randoms(self.id, test_questions_count*test_questions_count, min = 0, test_questions_count-1, 0).uniq | Array(0..test_questions_count-1) #After pipe: Fill with missing Elements
		counter=0
		next_question = test_questions[static_random_order[counter]]
		while next_question.answered_by?(user)
			next_question = test_questions[static_random_order[counter]]
			counter += 1;
		end
	else
	    next_question = (self.questions - user.questions).first
	end

	next_question && [self, next_question]
  end
end
