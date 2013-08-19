FactoryGirl.define do
	sequence :email do |n| 
		"email#{n}@factory.com"
	end

	factory :user do
		email
		password "secret"
		role User::ROLES[:registered]
	end

end