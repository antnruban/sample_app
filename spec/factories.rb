FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person-#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    email_confirmed true
    confirm_token nil

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem Ipsum"
    user
  end
end
