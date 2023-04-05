class AuthorSerializer
  include JSONAPI::Serializer

  attributes :full_name, :nick_name, :biography
  has_many :books, through: :author_books
  has_many :author_books, dependent: :destroy
end
