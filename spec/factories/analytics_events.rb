FactoryBot.define do
  factory :analytics_event do
    association :user
    association :learning_path
    event_type { "user.lesson_completed" }
    lesson_id { BSON::ObjectId.new.to_s }
    payload { { "key" => "value" } }
  end
end
