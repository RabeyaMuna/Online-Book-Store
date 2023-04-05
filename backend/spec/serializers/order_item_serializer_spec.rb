require 'rails_helper'

RSpec.describe OrderItemSerializer do
  let(:order_item) { FactoryBot.create(:order_item) }
  let(:result) { OrderItemSerializer.new(order_item).serializable_hash }

  let(:expected_hash) do
    {
      data: {
        id: order_item.id.to_s,
        type: :order_item,
        attributes: {
          quantity: order_item.quantity,
          book_id: order_item.book_id,
          order_id: order_item.order_id,
        },
      },
    }
  end

  it 'serializes json data' do
    expect(result).to eq(expected_hash)
  end
end
