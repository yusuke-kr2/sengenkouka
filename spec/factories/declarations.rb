FactoryBot.define do
  factory :declaration do
    content { "テスト宣言" }
    deadline { Date.today + 1 }
    status { :declaring }
    association :user
  end
end
