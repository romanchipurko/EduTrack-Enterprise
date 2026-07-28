FactoryBot.define do
  factory :question do
    text { 'What is the correct answer?' }
    options { [ 'Option A', 'Option B', 'Option C' ] }
    correct_answer { 1 }
  end
end
