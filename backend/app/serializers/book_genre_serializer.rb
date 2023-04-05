class BookGenreSerializer
  include JSONAPI::Serializer
  attributes :book_id, :genre_id

  belongs_to :book
  belongs_to :genre
end
