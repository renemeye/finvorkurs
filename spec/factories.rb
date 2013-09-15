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

		factory :tutor do
			role User::ROLES[:tutor]
		end

		factory :preregistered do
			role User::ROLES[:preregistered]
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

		factory :vorkurs_test_with_questions do
			ignore do
				question_count 4
			end
			after(:create) do |vorkurs_test, evaluator|
				FactoryGirl.create_list(:question_with_odd_correct_answers, evaluator.question_count, vorkurs_test: vorkurs_test)
			end
		end
	end

	factory :answer do
		text "Answer foo"
		after(:create) do |answer, evaluator|
			answer.correct= answer.id.odd?
			answer.save
      	end
	end

	factory :course do
		title "Ein Kurs"
	    description "Eine Beschreibung"
	    course_level "First Course Level"
	    factory :course_with_groups do
    		ignore do
				group_count 4
			end
			after(:create) do |course, evaluator|
        		FactoryGirl.create_list(:group, evaluator.group_count, course: course)
      		end
		end
	end

	factory :degree_program do
		name "Program 1"
		degree "Degree 1"
		his_id 1
	end

	factory :group do
	end

	factory :faculty do
		name "Faculty 1"
		short_name "F1"

		factory :faculty_with_programs do
			ignore do
				programs_count 4
			end
			after(:create) do |faculty, evaluator|
        		FactoryGirl.create_list(:degree_program, evaluator.programs_count, faculty: faculty)
      		end
		end
	end

end