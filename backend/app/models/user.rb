class User < ApplicationRecord
  include Clearance::User
  include Resources
  include ContentType

  has_one_attached :avatar
  has_many :orders, dependent: :destroy
  has_many :book_reviews, dependent: :destroy
  has_many :books, through: :book_reviews
  has_many :images, as: :imageable, dependent: :destroy

  ROLES = { admin: 0, user: 1 }.freeze
  enum role: ROLES

  phony_normalize :phone, default_country_code: 'BD'

  validates :name, presence: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { in: 6..20 }
  validates_plausible_phone :phone,
                            presence: true,
                            with: VALID_PHONE_REGEX
  validates_uniqueness_of :phone
end
