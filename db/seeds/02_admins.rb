User.find_or_create_by!(email: "admin@example.com", role: "admin") do |user|
  user.password = "passworD1"
  user.password_confirmation = "passworD1"
end
