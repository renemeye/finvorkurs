FactoryGirl.define do
	sequence :email do |n| 
		"email#{n}@factory.com"
	end

	factory :user do
		email
		password "secret"
		role User::ROLES[:registered]

		factory :admin do
			role User::ROLES[:admin]
		end
	end

	factory :question do
		association :vorkurs_test
		question_type Question::TYPES[:singleSelect]
		category "Simple Questions"

		factory :question_with_odd_correct_answers do
			ignore do
				answers_count 8
			end
			after(:create) do |question, evaluator|
        		FactoryGirl.create_list(:answer, evaluator.answers_count, question: question)
      		end
		end
	end

	factory :vorkurs_test do
		name "Simple Test"
	end

	factory :answer do
		text "Answer foo"
		after(:create) do |answer, evaluator|
			answer.correct= answer.id.odd?
			answer.save
      	end
	end

end