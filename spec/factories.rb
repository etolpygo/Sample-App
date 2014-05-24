FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@allsparks.com"}
    password "spraks?"
    password_confirmation "spraks?"
  end
end