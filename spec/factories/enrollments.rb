FactoryBot.define do
  factory :enrollment do
    user
    learning_path
    progress_percentage { 0 }
    completed_item_ids { [] }

    trait :in_progress do
      progress_percentage { 50 }
      completed_item_ids { [ BSON::ObjectId.new.to_s ] }
    end

    trait :completed do
      progress_percentage { 100 }
      completed_item_ids { [ BSON::ObjectId.new.to_s, BSON::ObjectId.new.to_s ] }
    end
  end
end
