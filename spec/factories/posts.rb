FactoryBot.define do
  factory :post do
    content {"Post Content"}
    association :user
  end
end
