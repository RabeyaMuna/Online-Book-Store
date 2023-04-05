class AuthorBook < ApplicationRecord
  belongs_to :author, inverse_of: :author_books
  belongs_to :book, inverse_of: :author_books
end
