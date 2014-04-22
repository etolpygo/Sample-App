FactoryGirl.define do
  factory :user do
    name     "Another User"
    email    "another@example.com"
    password "baz-bar-foo"
    password_confirmation "baz-bar-foo"
  end
end