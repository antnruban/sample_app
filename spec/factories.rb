FactoryGirl.define do
  factory :user do
    name     "Name Surname"
    email    "name@post.dom"
    password "foobar"
    password_confirmation "foobar"
  end
end
