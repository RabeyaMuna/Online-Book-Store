FactoryBot.define do
  factory :image do
    image_path { Faker::Avatar.image }
    name { Faker::Book.title }
    imageable_id { Faker::Number.number(digits: 10) }
    trait :for_book do
      association :imageable, factory: :book
    end
  end
end
