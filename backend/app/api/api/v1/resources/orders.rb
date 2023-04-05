module API
  module V1
    module Resources
      class Orders < Base

        resource :orders do
          desc 'index'
          get do
            orders = Order.all
            present paginate(orders), with: API::V1::Entities::Order
          end

          desc 'show a specific order'
          route_param :id do
            get do
              order = Order.find(params[:id])
              order_items = order.order_items
              data = { order: order, order_items: paginate(order_items) }
              present data
            end
          end

          desc 'create a new order'
          params do
            requires :order, type: Hash do
              requires :user_id, type: Integer
              requires :delivery_address, type: String
              optional :order_status, type: String
              optional :total_bill, type: Float
              requires :order_items_attributes, type: Array do
                requires :book_id, type: Integer
                requires :quantity, type: Integer
              end
            end
          end

          post do
            present OrderCreator.call(params)
          end

          ## Commenting out the Implementation without service class,
          ## as we added for study purpose
          # post do
          #   current_order
          #   if @order.save
          #     data = { order: @order, message: 'Order Successfully Created' }
          #     present data
          #   else
          #     error = { error: @order.errors.messages, message: 'Order Creation Failed' }
          #     present error
          #   end
          # end

          desc 'Update an order'
          params do
            requires :order, type: Hash do
              optional :user_id, type: Integer
              optional :delivery_address, type: String
              optional :order_status, type: String
              optional :total_bill, type: Float
            end
          end

          route_param :id do
            patch do
              order = Order.find(params[:id])
              if order.update(params[:order])
                data = { order: order, message: 'Order Successfully Updated' }
                present data
              else
                error = { error: order.errors.messages, message: 'Order Failed to Update' }
                present error
              end
            end
          end

          desc 'delete an order'
          route_param :id do
            delete do
              order = Order.find(params[:id])
              if order.destroy
                data = { order: order, message: 'Order Successfully Deleted' }
                present data
              else
                error = { error: order.errors.messages, message: 'Order Failed to Delete' }
                present error
              end
            end
          end
        end

        helpers do
          def current_order
            @order = Order.find_by(user_id: params[:order][:user_id], order_status: :pending)
            if @order.nil?
              @order = Order.new(params[:order])
            else
              params[:order][:order_items_attributes].each do |item|
                book_id = item[:book_id]
                order_item = @order.order_items.find_by(book_id: book_id)
                if order_item.nil?
                  @order.assign_attributes(params[:order])
                else
                  order_item.update(quantity: item[:quantity].to_i)
                end
              end
            end
          end
        end
      end
    end
  end
end
