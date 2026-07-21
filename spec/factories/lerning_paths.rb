FactoryBot.define do
  factory :learning_path do
    title { "Ruby on Rails" }
    description { Faker::Lorem.paragraph }
  end
end
