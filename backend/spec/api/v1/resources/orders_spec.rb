require 'rails_helper'

RSpec.describe API::V1::Resources::Orders do
  let(:book_1) { FactoryBot.create(:book) }
  let(:book_2) { FactoryBot.create(:book) }

  let(:user) { FactoryBot.create(:user) }

  let(:order_1) { FactoryBot.create(:order) }
  let!(:order_2) { FactoryBot.create(:order) }

  let!(:order_item_1) { FactoryBot.create(:order_item, book_id: book_1.id, order_id: order_1.id) }
  let!(:order_item_2) { FactoryBot.create(:order_item, book_id: book_2.id, order_id: order_1.id) }

  let(:request_url) { '/api/v1/orders' }

  describe 'GET /orders' do
    before { get request_url }

    it 'checks the count of orders' do
      expect(JSON.parse(response.body).size).to eq(2)
    end

    it 'shows 200 ok status' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /orders/:id' do
    context 'with valid attributes' do
      before { get "/api/v1/orders/#{order_1.id}" }

      it 'gets a specific order with its order items' do
        parsed_json = JSON.parse(response.body)

        expect(parsed_json['order']['id'].to_i).to eq(order_1.id)
        expect(parsed_json['order_items'].size).to eq(2)
        expect(parsed_json['order_items'][0]['id'].to_i).to eq(order_item_1.id)
        expect(parsed_json['order_items'][1]['id'].to_i).to eq(order_item_2.id)
      end

      it 'shows 200 ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      before { get '/api/v1/orders/0' }

      it 'shows 404 Not Found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'shows an error message' do
        expect(JSON.parse(response.body)['message']).to eq("Couldn't find Order with 'id'=0")
      end
    end
  end

  describe 'POST /orders' do
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

      let(:create_action_1) { post request_url, params: valid_order_params_1 }
      let(:create_action_2) { post request_url, params: valid_order_params_2 }
      let(:create_action_3) { post request_url, params: valid_order_params_3 }

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

      it 'returns 201 created status' do
        create_action_1

        expect(response).to have_http_status(:created)
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

      let(:create_action) { post request_url, params: invalid_order_params }

      it 'does not create a new order' do
        expect { create_action }.to_not change(OrderItem, :count)
        expect { create_action }.to_not change(Order, :count)
      end
    end
  end

  describe 'PATCH /orders/:id' do
    context 'with valid attributes' do
      let(:valid_update_params) do
        {
          "order": {
            "delivery_address": 'Mirpur', "order_status": :delivered,
          },
        }
      end

      let(:update_action) { patch request_url + "/#{order_1.id}", params: valid_update_params }

      it 'updates the order' do
        update_action
        order_1.reload

        expect(order_1.delivery_address).to eq('Mirpur')
        expect(order_1.order_status).to eq('delivered')
      end

      it 'shows 200 ok status' do
        update_action

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_update_params) do
        {
          "order": {
            "delivery_address": '', "user_id": 0,
          },
        }
      end

      let(:update_action) { patch request_url + '/0', params: invalid_update_params }
      it 'does not update the order' do
        update_action
        order_1.reload

        expect(order_1.delivery_address).to_not eq('')
        expect(order_1.user_id).to_not eq(0)
      end

      it 'shows 404 not found status' do
        update_action

        expect(response).to have_http_status(:not_found)
      end

      it 'shows an error message' do
        update_action

        expect(JSON.parse(response.body)['message']).to eq("Couldn't find Order with 'id'=0")
      end
    end
  end

  describe 'DELETE /orders/:id' do
    context 'with valid attributes' do
      let(:delete_action) { delete request_url + "/#{order_1.id}" }

      it 'deletes the order from database' do
        expect { delete_action }.to change(Order, :count).by(-1)
      end

      it 'deletes the corresponding order items from database' do
        expect { delete_action }.to change(OrderItem, :count).by(-2)
      end

      it 'shows 200 ok status' do
        delete_action

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      let(:delete_action) { delete request_url + '/0' }

      it 'does not delete anything from database' do
        expect { delete_action }.to_not change(Order, :count)
        expect { delete_action }.to_not change(OrderItem, :count)
      end

      it 'shows 404 Not Found status' do
        delete_action

        expect(response).to have_http_status(:not_found)
      end

      it 'shows an error message' do
        delete_action

        expect(JSON.parse(response.body)['message']).to eq("Couldn't find Order with 'id'=0")
      end
    end
  end
end
