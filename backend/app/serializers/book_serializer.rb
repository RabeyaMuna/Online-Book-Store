class BookSerializer
  include JSONAPI::Serializer

  attributes :name, :price, :total_copies, :copies_sold, :publication_year

  has_many :author_books, dependent: :destroy, inverse_of: :book
  has_many :authors, through: :author_books
  has_many :book_reviews, dependent: :destroy
  has_many :users, through: :book_reviews
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
end
