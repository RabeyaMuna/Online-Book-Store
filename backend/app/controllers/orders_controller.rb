class OrdersController < ApplicationController
  before_action :find_order, only: %i(show edit update destroy update_status)

  def index
    @orders = Order.includes(:user).all
  end

  def show
    @order_items = @order.order_items
    respond_to do |format|
      format.html
      format.pdf do
        pdf = OrderReceiptPdf.call(@order)
        send_data pdf.render,
                  filename: "order_#{@order.id}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  def create
    fetch_current_order
    if @order.save
      flash[:success] = I18n.t('notice.create.success', resource: humanize(Order))
    else
      flash[:error] = I18n.t('notice.create.fail', resource: humanize(Order))
    end
    redirect_to books_path
  end

  def edit
    @order_item = OrderItem.find_by(order_id: params[:id])
  end

  def update
    if @order.update(order_params)
      flash[:notice] = I18n.t('notice.update.success', resource: humanize(Order))
      redirect_to order_path(@order)
    else
      flash[:error] = I18n.t('notice.update.fail', resource: humanize(Order))
      render :edit
    end
  end

  def destroy
    if @order.destroy
      flash[:success] = I18n.t('notice.delete.success', resource: humanize(Order))
    else
      flash[:error] = I18n.t('notice.delete.fail', resource: humanize(Order))
    end

    if current_user.admin?
      redirect_to orders_path
    else
      redirect_to books_path
    end
  end

  def update_status
    if @order.pending?
      if @order.delivery_address.nil?
        flash[:error] = I18n.t('notice.order.error')
        redirect_to order_path
      else
        @order.update(order_status: :placed)

        flash[:success] = I18n.t('notice.order.success')
        OrderReceiptMailer.with(order: @order).order_receipt_email.deliver_later
        redirect_to books_path
      end
    end
  end

  private

  def fetch_current_order
    @order = Order.find_by(user_id: current_user.id, order_status: :pending)
    if @order.nil?
      @order = Order.new(order_params)
    else
      book_id = params[:order][:order_items_attributes][0][:book_id].to_i
      order_item = @order.order_items.find_by(book_id: book_id)
      @order.assign_attributes(order_params) if order_item.nil?
    end
  end

  def find_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :user_id,
      :delivery_address,
      :order_status,
      order_items_attributes: %i(id book_id quantity _destroy),
    ).merge({ user_id: current_user.id })
  end
end
