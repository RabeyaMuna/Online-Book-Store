FactoryBot.define do
  factory :book do
    total_item = Faker::Number.within(range: 1..500)
    name { Faker::Book.title }
    total_copies { total_item }
    price { Faker::Number.within(range: 0.0..100.0) }
    copies_sold { Faker::Number.within(range: 0..total_item) }
    publication_year { Faker::Date.in_date_period(year: 2018) }
  end
end
