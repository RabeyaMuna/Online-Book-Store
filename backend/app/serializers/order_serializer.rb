class OrderSerializer
  include JSONAPI::Serializer

  attributes :order_status, :delivery_address, :total_bill, :user_id
end
