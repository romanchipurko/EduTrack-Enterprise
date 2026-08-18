FactoryBot.define do
  factory :course_content do
    learning_path_id { SecureRandom.uuid }
    sequence(:title) { |n| "Lesson #{n}" }
    sequence(:position) { |n| n }
    elements do
      [
        Elements::Markdown.new(_type: 'Elements::Markdown',  body: "## Welcome\nThis is text.", position: 1),
        Elements::Video.new(_type: 'Elements::Video', url: "https://example.com/lesson.mp4", position: 2)
      ]
    end

    trait :with_code_block do
      elements do
        [ Elements::Code.new(_type: 'Elements::Code', language: "ruby", content: "puts 'Hello, Mongoid!'", position: 1) ]
      end
    end

    trait :empty_elements do
      elements { [] }
    end
  end
end
