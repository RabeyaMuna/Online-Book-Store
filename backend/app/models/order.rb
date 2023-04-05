class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy, inverse_of: :order
  has_many :books, through: :order_items

  STATUS = { pending: 0,
             placed: 1,
             delivered: 2, }.freeze
  enum order_status: STATUS

  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank

  validates :total_bill,
            :order_status,
            presence: true

  validates :delivery_address, presence: true, if: :valid_order_status

  attribute :total_bill, :float, default: 0.0

  before_save :update_total_bill

  def update_total_bill
    self.total_bill = 0.0
    order_items.each do |order_item|
      self.total_bill += (order_item.quantity * order_item.book.price)
    end
    self.total_bill = self.total_bill.round(2)
  end

  private

  def valid_order_status
    placed? || delivered?
  end
end
