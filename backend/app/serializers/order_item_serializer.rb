class OrderItemSerializer
  include JSONAPI::Serializer

  attributes :quantity, :book_id, :order_id
end
