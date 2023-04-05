class OrderCreator < ApplicationService
  attr_accessor :order, :user_id, :delivery_address, :total_bill, :order_status, :order_items_attributes

  def initialize(params)
    @user_id = params[:order][:user_id]
    @delivery_address = params[:order][:delivery_address]
    @order_status = params[:order][:order_status] || :pending
    @total_bill = params[:order][:total_bill] || 0.0
    @order_items_attributes = params[:order][:order_items_attributes]
    @order = initialize_order
  end

  def call
    update_order_items unless order.id.nil?

    return order if order.save

    order.errors.messages
  end

  private

  def initialize_order
    find_order || Order.new(user_id: user_id,
                            delivery_address: delivery_address,
                            total_bill: total_bill,
                            order_status: order_status,
                            order_items_attributes: order_items_attributes)
  end

  def find_order
    Order.find_by(user_id: user_id, order_status: :pending)
  end

  def update_order_items
    order_items_attributes.each do |item|
      book_id = item[:book_id]
      order_item = order.order_items.find_by(book_id: book_id)
      if order_item.nil?
        order.assign_attributes(order_items_attributes: [item])
      else
        order_item.update(quantity: item[:quantity].to_i)
      end
    end
  end
end
