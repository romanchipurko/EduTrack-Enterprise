FactoryBot.define do
  factory :quiz do
    title { 'Ruby Basics Quiz' }

    course_content

    trait :with_questions do
      after(:build) { |quiz| quiz.questions << build(:question) }
    end
  end
end
