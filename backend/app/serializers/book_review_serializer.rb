class BookReviewSerializer
  include JSONAPI::Serializer

  attributes :review, :rating, :book_id, :user_id

  belongs_to :book
  belongs_to :user
end
