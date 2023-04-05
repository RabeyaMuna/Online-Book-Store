class Book < ApplicationRecord
  include ContentType

  validates :name, :price, :total_copies, presence: true
  validates :total_copies, numericality: { greater_than: 0 }

  has_one_attached :avatar
  has_many :author_books, dependent: :destroy, inverse_of: :book
  has_many :authors, through: :author_books
  has_many :book_genres, dependent: :destroy, inverse_of: :book
  has_many :genres, through: :book_genres
  has_many :book_reviews, dependent: :destroy
  has_many :users, through: :book_reviews
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  has_many :images, as: :imageable, dependent: :destroy

  scope :search_book, lambda { |query, book_id_list|
                        where(['name ILIKE ?', "%#{query}%"]).or(where(id: book_id_list))
                      }

  ransack_alias :author, :authors_full_name_or_authors_nick_name_or_authors_biography
end
