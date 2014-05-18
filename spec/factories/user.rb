FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "email#{n}@example.com" }
    sequence(:login)  {|n| "login#{n}" }
    password 'password'
  end
end
