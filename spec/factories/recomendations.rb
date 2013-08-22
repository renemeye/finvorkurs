# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recomendation do
    min_percentage 1
    course_level "MyString"
    vorkurs_test nil
  end
end
