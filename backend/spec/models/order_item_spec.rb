require 'rails_helper'

RSpec.describe OrderItem do
  describe 'Validating Factory' do
    let(:order_item) { FactoryBot.build(:order_item) }
    
    it 'is a valid order item' do
      expect(order_item).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:order) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_inclusion_of(:quantity).in_range(1..100) }
  end
end
