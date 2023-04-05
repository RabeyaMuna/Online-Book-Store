class Author < ApplicationRecord
  has_many :author_books, dependent: :destroy, inverse_of: :author
  has_many :books, through: :author_books

  scope :search_author, lambda { |query|
                          where(['full_name ILIKE ? OR nick_name ILIKE ? OR biography ILIKE ?', "%#{query}%", "%#{query}%", "%#{query}%"])
                        }

  validates :full_name,
            :nick_name,
            :biography,
            presence: true
end
