class BookReview < ApplicationRecord
  belongs_to :book
  belongs_to :user

  RATINGS = { very_bad: 1,
              bad: 2,
              good: 3,
              very_good: 4,
              excellent: 5, }.freeze
  enum rating: RATINGS

  validates :review, :rating, presence: true
  validates :rating, inclusion: { in: ratings }
end
