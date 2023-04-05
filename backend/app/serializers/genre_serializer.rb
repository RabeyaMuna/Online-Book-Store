class GenreSerializer
  include JSONAPI::Serializer
  attributes :name
  
  has_many :book_genres, dependent: :destroy, inverse_of: :genre
  has_many :books, through: :book_genres
end
