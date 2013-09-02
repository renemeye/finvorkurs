# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :newsletter do
    subject "MyString"
    content "MyText"
    author nil
    state "MyString"
  end
end
