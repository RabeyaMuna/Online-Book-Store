require 'rails_helper'

RSpec.describe Rest::V1::OrdersController do
  let(:book_1) { FactoryBot.create(:book) }
  let(:book_2) { FactoryBot.create(:book) }

  let(:user) { FactoryBot.create(:user) }

  let(:order_1) { FactoryBot.create(:order) }
  let!(:order_2) { FactoryBot.create(:order) }

  let!(:order_item_1) { FactoryBot.create(:order_item, book_id: book_1.id, order_id: order_1.id) }
  let!(:order_item_2) { FactoryBot.create(:order_item, book_id: book_2.id, order_id: order_1.id) }

  describe 'GET #index' do
    before { get :index }

    it { is_expected.to respond_with(:ok) }

    it 'gets the list of orders' do
      parsed_json = JSON.parse(response.body)

      expect(parsed_json['order']['data'].size).to eq(2)
    end
  end

  describe 'GET #show' do
    context 'with valid attributes' do
      before { get :show, params: { id: order_1.id } }

      it { is_expected.to respond_with(:ok) }

      it 'gets a specific order with its order items' do
        parsed_json = JSON.parse(response.body)

        expect(parsed_json['order']['data']['id'].to_i).to eq(order_1.id)
        expect(parsed_json['order_item']['data'].size).to eq(2)
        expect(parsed_json['order_item']['data'][0]['id'].to_i).to eq(order_item_1.id)
        expect(parsed_json['order_item']['data'][1]['id'].to_i).to eq(order_item_2.id)
      end
    end

    context 'with invalid attributes' do
      before { get :show, params: { id: 0 } }

      it { is_expected.to rescue_from(ActiveRecord::RecordNotFound) }
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      def order_attributes(user_id, book_id, quantity = 1)
        order_item_attributes = FactoryBot.attributes_for(:order_item, book_id: book_id, quantity: quantity)

        FactoryBot.attributes_for(:order, user_id: user_id, order_items_attributes: [order_item_attributes])
      end

      def create_action(order_params)
        post :create, params: { order: order_params }
      end

      let(:valid_order_params_1) { order_attributes(user.id, book_1.id) }
      let(:valid_order_params_2) { order_attributes(user.id, book_1.id, 5) }
      let(:valid_order_params_3) { order_attributes(user.id, book_2.id) }

      let(:create_action_1) { create_action(valid_order_params_1) }
      let(:create_action_2) { create_action(valid_order_params_2) }
      let(:create_action_3) { create_action(valid_order_params_3) }

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
          expect(OrderItem.last.quantity).to_not eq(valid_order_params_1[:order_items_attributes][0][:quantity])
          expect(OrderItem.last.quantity).to eq(valid_order_params_2[:order_items_attributes][0][:quantity])
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

      it 'shows ok status' do
        create_action_1

        is_expected.to respond_with(:ok)
      end

      it 'shows success message' do
        create_action_1

        expect(JSON.parse(response.body)['message']).to eq(I18n.t('notice.create.success',
                                                                  resource: Order.model_name.human))
      end
    end

    context 'with invalid attributes' do
      let(:invalid_order_item_params) { FactoryBot.attributes_for(:order_item, book_id: 0) }
      let(:invalid_order_params) do
        FactoryBot.attributes_for(:order,
                                  user_id: 0,
                                  order_items_attributes: [invalid_order_item_params])
      end
      let(:create_action) { post :create, params: { order: invalid_order_params } }

      it 'does not create a new order' do
        expect { create_action }.to_not change(Order, :count)
        expect { create_action }.to_not change(OrderItem, :count)
      end

      it 'shows bad request status' do
        create_action

        is_expected.to respond_with(:bad_request)
      end

      it 'shows error message' do
        create_action

        expect(JSON.parse(response.body)['message']).to eq(I18n.t('notice.create.fail',
                                                                  resource: Order.model_name.human))
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before do
        patch :update,
              params: { id: order_1.id,
                        order: FactoryBot.attributes_for(:order,
                                                         delivery_address: 'Mirpur',
                                                         order_status: :delivered), }
      end

      it 'updates the order' do
        order_1.reload

        expect(order_1.delivery_address).to eq('Mirpur')
        expect(order_1.order_status).to eq('delivered')
      end

      it { is_expected.to respond_with(:ok) }
      it 'shows success message' do
        expect(JSON.parse(response.body)['message']).to eq(I18n.t('notice.update.success',
                                                                  resource: Order.model_name.human))
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update,
              params: { id: order_1.id,
                        order: FactoryBot.attributes_for(:order, delivery_address: '', user_id: 0), }
      end

      it 'does not update the order' do
        order_1.reload

        expect(order_1.delivery_address).to_not eq('')
        expect(order_1.user_id).to_not eq(0)
      end

      it { is_expected.to respond_with(:bad_request) }
      it 'shows error message' do
        expect(JSON.parse(response.body)['message']).to eq(I18n.t('notice.update.fail',
                                                                  resource: Order.model_name.human))
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid attributes' do
      let(:delete_action) { delete :destroy, params: { id: order_1.id } }

      it 'shows ok status' do
        delete_action

        is_expected.to respond_with(:ok)
      end

      it 'deletes the order from database' do
        expect { delete_action }.to change(Order, :count).by(-1)
      end

      it 'deletes corresponding order items from database' do
        expect { delete_action }.to change(OrderItem, :count).by(-2)
      end

      it 'shows success message' do
        delete_action

        expect(JSON.parse(response.body)['message']).to eq(I18n.t('notice.delete.success',
                                                                  resource: Order.model_name.human))
      end
    end

    context 'with invalid attributes' do
      let(:delete_action) { delete :destroy, params: { id: 0 } }

      it 'does not delete anything from database' do
        expect { delete_action }.to_not change(Order, :count)
        expect { delete_action }.to_not change(OrderItem, :count)
      end

      it { is_expected.to rescue_from(ActiveRecord::RecordNotFound) }
    end
  end
end
