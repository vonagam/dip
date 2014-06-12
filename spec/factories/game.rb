FactoryGirl.define do
  factory :game do
    sequence(:name) {|n| "name#{n}" }
    powers_is_random false
    is_public false
    time_mode 'manual'
    chat_mode 'both'
    map { Map.find_by name: 'Standart' }
    association :creator, factory: :user
  end
end
