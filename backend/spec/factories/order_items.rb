FactoryBot.define do
  factory :order_item do
    quantity { Faker::Number.between(from: 1, to: 10) }
    book
    order
  end
end
