FactoryBot.define do
  factory :task do
    # sequence(:title){|n| "title{n}"}からの書き換え
    sequence(:title, "title1")
    content { "content" }
    status { :todo }
    deadline { 1.week.from_now }
    association :user
  end
end
