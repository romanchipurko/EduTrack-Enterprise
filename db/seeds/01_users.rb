5.times do |n|
  User.find_or_create_by!(email: "user#{n + 1}@example.com") do |user|
    user.password = "passwordA1"
    user.password_confirmation = "passwordA1"
  end
end
