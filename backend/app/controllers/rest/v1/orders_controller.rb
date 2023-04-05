module Rest
  module V1
    class OrdersController < RestController
      before_action :find_order, only: %i(show update destroy)

      def index
        @orders = Order.all
        render json: { order: OrderSerializer.new(@orders) }, status: :ok
      end

      def show
        @order_items = @order.order_items
        render json: { order: OrderSerializer.new(@order), order_item: OrderItemSerializer.new(@order_items) },
               status: :ok
      end

      def create
        current_order
        if @order.save
          render json: { data: OrderSerializer.new(@order),
                         message: I18n.t('notice.create.success', resource: humanize(Order)), },
                 status: :ok
        else
          render json: { message: I18n.t('notice.create.fail', resource: humanize(Order)) },
                 status: :bad_request
        end
      end

      def update
        if @order.update(order_update_params)
          render json: { data: OrderSerializer.new(@order),
                         message: I18n.t('notice.update.success', resource: humanize(Order)), },
                 status: :ok
        else
          render json: { message: I18n.t('notice.update.fail', resource: humanize(Order)) },
                 status: :bad_request
        end
      end

      def destroy
        if @order.destroy
          render json: { data: OrderSerializer.new(@order),
                         message: I18n.t('notice.delete.success', resource: humanize(Order)), },
                 status: :ok
        else
          render json: { message: I18n.t('notice.delete.fail', resource: humanize(Order)) },
                 status: :bad_request
        end
      end

      private

      def find_order
        @order = Order.find(params[:id])
      end

      def current_order
        @order = Order.find_by(user_id: params[:order][:user_id], order_status: :pending)
        if @order.nil?
          @order = Order.new(order_params)
        else
          params[:order][:order_items_attributes].each do |item|
            book_id = item[:book_id].to_i
            order_item = @order.order_items.find_by(book_id: book_id)
            if order_item.nil?
              @order.assign_attributes(order_params)
            else
              order_item.update(quantity: item[:quantity].to_i)
            end
          end
        end
      end

      def order_params
        params.require(:order).permit(
          :user_id,
          :delivery_address,
          :order_status,
          order_items_attributes: %i(id book_id quantity _destroy),
        )
      end

      def order_update_params
        params.require(:order).permit(
          :user_id,
          :delivery_address,
          :order_status,
        )
      end
    end
  end
end
