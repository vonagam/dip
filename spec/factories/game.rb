FactoryGirl.define do
  factory :game do
    ignore do
      progress_count nil
      sides_count 0
    end

    sequence(:name){ |n| "name#{n}" }
    powers_is_random false
    is_public false
    time_mode 'manual'
    chat_mode 'both'
    map{ Map.find_by name: 'Standart' }
    association :creator, factory: :user

    after(:create) do |game, evaluator|
      evaluator.sides_count.times do create :side, game: game end
      
      if evaluator.progress_count
        game.start
        evaluator.progress_count.times do game.progress end
      end
    end
  end
end
