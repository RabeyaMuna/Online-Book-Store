class Genre < ApplicationRecord
  has_many :book_genres, dependent: :destroy, inverse_of: :genre
  has_many :books, through: :book_genres

  validates :name, presence: true, uniqueness: true

  scope :search_genre, ->(query) { where(['name ILIKE ?', "%#{query}%"]) }
end
