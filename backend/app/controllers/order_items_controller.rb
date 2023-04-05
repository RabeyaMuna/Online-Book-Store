class OrderItemsController < ApplicationController
  before_action :find_order_item, only: %i(destroy update)

  def update
    updated_quantity = @order_item.quantity + params[:quantity].to_i
    updated_quantity > 0 ? @order_item.update!(quantity: updated_quantity) : @order_item.destroy!
    @order.save

    redirect_to order_path(@order)
  end

  def destroy
    if @order_item.destroy
      flash[:success] = I18n.t('notice.delete.success', resource: humanize(OrderItem))
    else
      flash[:error] = I18n.t('notice.delete.fail', resource: humanize(OrderItem))
    end
    @order.save

    redirect_to order_path(@order)
  end

  private

  def find_order_item
    @order_item = OrderItem.find(params[:id])
    @order = Order.find(@order_item['order_id'])
  end
end
