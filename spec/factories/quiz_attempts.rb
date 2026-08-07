FactoryBot.define do
  factory :quiz_attempt do
    user
    sequence(:quiz_id) { |n| "64694f4061ac4cdc98ca#{n.to_s.rjust(4, '0')}" }
    score { 2 }
    total { 3 }
  end
end
