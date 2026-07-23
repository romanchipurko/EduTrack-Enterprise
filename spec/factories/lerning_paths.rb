FactoryBot.define do
  factory :learning_path do
    sequence(:title) { |n| "Learning Path #{n}" }
    description { "Description of the learning path" }
  end
end
