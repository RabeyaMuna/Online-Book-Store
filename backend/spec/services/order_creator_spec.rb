require 'spec_helper'

RSpec.describe OrderCreator do
  let(:book_1) { FactoryBot.create(:book) }
  let(:book_2) { FactoryBot.create(:book) }

  let(:user) { FactoryBot.create(:user) }

  context 'with valid attributes' do
    let(:valid_order_item_params_1) do
      FactoryBot.attributes_for(:order_item, book_id: book_1.id, quantity: 1)
    end
    let(:valid_order_item_params_2) do
      FactoryBot.attributes_for(:order_item, book_id: book_1.id, quantity: 5)
    end
    let(:valid_order_item_params_3) do
      FactoryBot.attributes_for(:order_item, book_id: book_2.id, quantity: 1)
    end

    let(:valid_order_params_1) do
      {
        "order": {
          "user_id": user.id,
          "delivery_address": 'Dhanmondi',
          "order_items_attributes": [valid_order_item_params_1],
        },
      }
    end

    let(:valid_order_params_2) do
      {
        "order": {
          "user_id": user.id,
          "delivery_address": 'Dhanmondi',
          "order_items_attributes": [valid_order_item_params_2],
        },
      }
    end

    let(:valid_order_params_3) do
      {
        "order": {
          "user_id": user.id,
          "delivery_address": 'Dhanmondi',
          "order_items_attributes": [valid_order_item_params_3],
        },
      }
    end

    let(:create_action_1) { OrderCreator.call(valid_order_params_1) }
    let(:create_action_2) { OrderCreator.call(valid_order_params_2) }
    let(:create_action_3) { OrderCreator.call(valid_order_params_3) }

    context 'creates a new record' do
      it 'creates a new order in database' do
        expect { create_action_1 }.to change(Order, :count).by(1)
      end

      it 'creates a new record in OrderItems table' do
        expect { create_action_1 }.to change(OrderItem, :count).by(1)
      end
    end

    context 'updates the order item that is already added' do
      it 'does not create a new order in database' do
        create_action_1

        expect { create_action_2 }.to_not change(Order, :count)
      end

      it 'updates the existing order item' do
        create_action_1

        expect { create_action_2 }.to_not change(OrderItem, :count)
        expect(OrderItem.last.quantity).to_not eq(valid_order_params_1[:order][:order_items_attributes][0][:quantity])
        expect(OrderItem.last.quantity).to eq(valid_order_params_2[:order][:order_items_attributes][0][:quantity])
      end
    end

    context 'adds a new order item in the pending order' do
      it 'creates a new order item' do
        create_action_1

        expect { create_action_3 }.to change(OrderItem, :count).by(1)
      end

      it 'does not create a new order' do
        create_action_1

        expect { create_action_3 }.to_not change(Order, :count)
      end
    end
  end

  context 'with invalid attributes' do
    let(:invalid_order_item_params) { FactoryBot.attributes_for(:order_item, book_id: 0) }
    let(:invalid_order_params) do
      {
        "order": {
          "user_id": 0,
          "order_items_attributes": [invalid_order_item_params],
        },
      }
    end

    let(:create_action) { OrderCreator.call(invalid_order_params) }

    it 'does not create a new order' do
      expect { create_action }.to_not change(Order, :count)
    end

    it 'does not create a new order item' do
      expect { create_action }.to_not change(OrderItem, :count)
    end
  end
end
