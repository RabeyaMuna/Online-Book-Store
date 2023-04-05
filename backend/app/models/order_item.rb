class OrderItem < ApplicationRecord
  belongs_to :book
  belongs_to :order, inverse_of: :order_items

  validates :quantity, presence: true, inclusion: { in: 1..100 }
end
