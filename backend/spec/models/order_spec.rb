require 'rails_helper'

RSpec.describe Order do
  let!(:user) { FactoryBot.create(:user) }
  let(:order) do
    FactoryBot.create(:order, user_id: user.id, delivery_address: 'House Road, kakrail, Dhaka')
  end

  describe 'Validating Order Factory' do
    it 'is a valid Order' do
      expect(order).to be_valid
    end
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:total_bill) }
    it { is_expected.to validate_presence_of(:order_status) }
    it { is_expected.to define_enum_for(:order_status).with_values(%i(pending placed delivered)) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:order_items).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:order_items) }
  end

  describe 'validate delivery_address scopes' do
    context 'when order status is pending' do
      it { is_expected.not_to validate_presence_of(:delivery_address) }
    end

    context 'when order status is placed' do
      it 'is expected to validate the presence of delivery_address' do
        order.update(order_status: :placed)

        expect(order.delivery_address).to be_present
      end
    end

    context 'when order status is delivered' do
      it 'is expected to validate the presence of delivery_address' do
        order.update(order_status: :delivered)

        expect(order.delivery_address).to be_present
      end
    end
  end
end
