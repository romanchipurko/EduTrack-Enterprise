FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "Password123" }
    password_confirmation { "Password123" }
    role { :student }
  end

  trait :admin do
    role { 'admin' }
  end

  trait :instructor do
    role { 'instructor' }
  end

  trait :student do
    role { 'student' }
  end
end
