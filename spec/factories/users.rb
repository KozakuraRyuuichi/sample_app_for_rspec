FactoryBot.define do
  factory :user do
    # sequence(:email) { |n| "user#{n}@gmail.com"}からの書き換え
    sequence(:email, "user1@example.com")
    password { "password" }
    password_confirmation { "password" }
  end
end
