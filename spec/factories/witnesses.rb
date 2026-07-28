FactoryBot.define do
  factory :witness do
    association :user
    association :declaration
  end
end
