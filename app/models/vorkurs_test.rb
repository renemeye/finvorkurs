require 'mathjax_compatible_markdown'

class VorkursTest < ActiveRecord::Base
	has_many :answers, through: :questions
   	has_many :questions, order: :id
   	has_many :test_results
   	has_many :recomendations

    @@markdown_options = [
	    :autolink=>true, 
	    :disable_indented_code_blocks=>true, 
	    :no_intra_emphasis=>true,
	    :strikethrough=>true,
	    :underline=>true,
	    :lax_spacing => true,
	    :hard_wrap=>true
    ]
    @@markdown = Redcarpet::Markdown.new(MathjaxCompatibleMarkdown.new(*@@markdown_options), *@@markdown_options)

    attr_accessible :name, :description, :recomendations_attributes
    accepts_nested_attributes_for :recomendations


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

  	def result user
  		user.test_result self
  	end

	
	def markdown_description
   		@@markdown.render(self.description)
  	end

end
