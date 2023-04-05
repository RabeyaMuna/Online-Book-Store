require 'rails_helper'

RSpec.describe OrderSerializer do
  let(:order) { FactoryBot.create(:order) }
  let(:result) { OrderSerializer.new(order).serializable_hash }

  let(:expected_hash) do
    {
      data: {
        id: order.id.to_s,
        type: :order,
        attributes: {
          order_status: order.order_status,
          delivery_address: order.delivery_address,
          total_bill: order.total_bill,
          user_id: order.user_id,
        },
      },
    }
  end

  it 'serializes json data' do
    expect(result).to eq(expected_hash)
  end
end
