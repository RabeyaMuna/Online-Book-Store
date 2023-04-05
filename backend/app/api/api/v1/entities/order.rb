module API
  module V1
    module Entities
      class Order < Base
        expose :user_id
        expose :delivery_address
        expose :order_status
        expose :total_bill
      end
    end
  end
end
