require 'rails_helper'

RSpec.describe API::V1::Entities::Order do
  let(:order) { FactoryBot.create(:order) }
  let(:order_entity) { API::V1::Entities::Order.represent(order) }
  let(:expected_output) { JSON.parse(order_entity.to_json) }

  let(:result) do
    {
      'id' => order.id,
      'user_id' => order.user_id,
      'delivery_address' => order.delivery_address,
      'order_status' => order.order_status,
      'total_bill' => order.total_bill,
    }
  end

  it 'matches the api specification' do
    expect(expected_output).to eq(result)
  end
end
