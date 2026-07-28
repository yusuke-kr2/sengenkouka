FactoryBot.define do
  factory :notification do
    association :user
    association :actor, factory: :user
    association :declaration
    read { false }
  end
end
