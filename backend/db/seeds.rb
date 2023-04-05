# This file should contain all the record creation needed to seed the database with its default values.
user =
  User.find_or_create_by(email: 'user1@gmail.com') do |u|
    u.name = 'user'
    u.password = '123456'
    u.phone = '+8801711111112'
    u.role = :user
  end
user.images.create(image_path: Faker::Avatar.image, name: Faker::Book.title)

admin =
  User.find_or_create_by(email: 'admin1@gmail.com') do |u|
    u.name = 'admin'
    u.password = '1234567'
    u.phone = '+8801761111112'
    u.role = :admin
  end
admin.images.create(image_path: Faker::Avatar.image, name: Faker::Book.title)

5.times do
  Genre.create_or_find_by(name: Faker::Book.genre)

  total_item = Faker::Number.within(range: 1..500).to_i
  book =
    Book.find_or_create_by(name: Faker::Book.title) do |b|
      b.name = Faker::Book.title
      b.total_copies = total_item
      b.price = Faker::Number.within(range: 0.0..10_000.0)
      b.copies_sold = Faker::Number.within(range: 0..total_item)
      b.publication_year = Faker::Date.in_date_period(year: 2018)
    end
  book.images.create(image_path: Faker::Avatar.image, name: Faker::Book.title)
  BookReview.create_or_find_by([{ rating: Faker::Number.between(from: 1, to: 5),
                                  review: Faker::Hipster.paragraphs,
                                  book_id: Book.all.sample.id,
                                  user_id: User.all.sample.id, }])

  Author.create_or_find_by([{ full_name: Faker::Name.name,
                              nick_name: Faker::Name.last_name,
                              biography: Faker::Hipster.paragraph, }])

  Order.create([{ total_bill: Faker::Number.decimal(l_digits: 6, r_digits: 2),
                  order_status: Faker::Number.between(from: 0, to: 2),
                  delivery_address: Faker::Address.full_address,
                  user_id: User.all.sample.id, }])
end

5.times do
  OrderItem.create_or_find_by([{ quantity: Faker::Number.between(from: 1, to: 100),
                                 book_id: Book.all.sample.id,
                                 order_id: Order.all.sample.id, }])
end

5.times do
  AuthorBook.create_or_find_by(author_id: Author.all.sample.id,
                               book_id: Book.all.sample.id)
end

5.times do
  BookGenre.create_or_find_by(genre_id: Genre.all.sample.id,
                              book_id: Book.all.sample.id)
end
