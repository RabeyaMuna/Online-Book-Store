class UserSerializer
  include JSONAPI::Serializer

  attributes :name, :email, :password, :phone, :role

  has_many :orders, dependent: :destroy
  has_many :book_reviews, dependent: :destroy
  has_many :books, through: :book_reviews
end
