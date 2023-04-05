class BookGenre < ApplicationRecord
  belongs_to :genre, inverse_of: :book_genres
  belongs_to :book, inverse_of: :book_genres
end
