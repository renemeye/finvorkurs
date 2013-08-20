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
		category "Simple Test"
	end

	factory :vorkurs_test do
		name "Simple Test"
	end

end