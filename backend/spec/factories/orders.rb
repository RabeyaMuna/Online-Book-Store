FactoryBot.define do
  factory :order do
    total_bill { 0.0 }
    order_status { :pending }
    delivery_address { Faker::Address.full_address }
    user
  end
end
