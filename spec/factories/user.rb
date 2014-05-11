FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "email#{n}@example.com" }
    sequence(:name)  {|n| "name#{n}" }
    password 'password'
  end
end
