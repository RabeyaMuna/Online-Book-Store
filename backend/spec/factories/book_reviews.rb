FactoryBot.define do
  factory :book_review do
    review { Faker::Hipster.paragraphs }
    rating { Faker::Number.between(from: 1, to: 5) }
    book
    user
  end
end
