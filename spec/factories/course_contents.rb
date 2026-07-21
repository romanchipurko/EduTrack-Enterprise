FactoryBot.define do
  factory :course_content do
    learning_path_id { SecureRandom.uuid }
    sequence(:title) { |n| "Урок #{n}" }
    sequence(:position) { |n| n }
    elements do
      [
        { "type" => "markdown", "body" => "## Добро пожаловать\nЭто текст урока." },
        { "type" => "video", "url" => "https://example.com/lesson.mp4" }
      ]
    end

    trait :with_code_block do
      elements { [ { "type" => "code_block", "language" => "ruby", "code" => "puts 'Hello, Mongoid!'" } ] }
    end

    trait :empty_elements do
      elements { [] }
    end
  end
end
