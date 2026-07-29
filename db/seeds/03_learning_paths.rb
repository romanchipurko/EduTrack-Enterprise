5.times do |n|
  LearningPath.find_or_create_by!(title: "Some course #{n+1}") do |lp|
    lp.description = Faker::Lorem.paragraph(sentence_count: 3)
  end
end
