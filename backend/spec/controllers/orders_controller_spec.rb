require 'rails_helper'

RSpec.describe OrdersController do
  let(:book) { FactoryBot.create(:book) }
  let(:user) { FactoryBot.create(:user) }
  let!(:order_1) do
    FactoryBot.create(
      :order,
      user_id: user.id,
      delivery_address: 'kakrail, Dhaka-1000',
      total_bill: 0.0,
      order_status: :placed,
    )
  end
  let(:order_2) do
    FactoryBot.create(
      :order,
      user_id: user.id,
      delivery_address: 'Aftabnagar Dhaka',
      total_bill: 0.0,
      order_status: :placed,
    )
  end
  let!(:order_item_2) { FactoryBot.create(:order_item, book_id: book.id, order_id: order_2.id) }

  before do
    sign_in_as user
  end

  describe 'GET #index' do
    before { get :index }

    it { is_expected.to respond_with(:success) }

    it 'assigns all orders into @orders' do
      expect(assigns(:orders)).to match_array([order_1, order_2])
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    context 'With valid attributes' do
      before { get :show, params: { id: order_1.id } }

      it 'assigns the orders to @order' do
        expect(assigns(:order)).to eq(order_1)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'with invalid attributes' do
      before { get :show, params: { id: 0 } }
      it { is_expected.to set_flash[:error].to(I18n.t('notice.not_found', resource: Order.model_name.human)) }
    end

    context 'when it is a pdf request' do
      let(:generate_pdf) { OrderReceiptPdf.call(order_1).render }
      let(:show_action) { get :show, params: { id: order_1.id }, format: :pdf }

      it 'returns a pdf attachment and matches with pdf' do
        show_action

        expect(response.content_type).to eq('application/pdf')
        expect(response.body).to eq(generate_pdf)
      end

      it 'sets filename for OrderReceiptPDF' do
        show_action

        expect(response.headers['Content-Disposition']).to eq("inline; filename=\"order_#{order_1.id}.pdf\"; filename*=UTF-8''order_#{order_1.id}.pdf")
      end
    end
  end

  describe 'POST #create' do
    context 'without nested attributes' do
      context 'with valid attributes' do
        let(:valid_order) do
          FactoryBot.attributes_for(
            :order,
            delivery_address: 'Gulshan, Dhaka',
          )
        end

        let(:create_action) { post :create, params: { order: valid_order } }

        it 'creates a new order into database' do
          expect { create_action }.to change(Order, :count).by(1)
        end

        it 'redirects to book index path' do
          expect(create_action).to redirect_to books_path
        end

        it 'shows flash message for success creation' do
          create_action

          expect(flash[:success]).to eq(I18n.t('notice.create.success', resource: Order.model_name.human))
        end
      end
    end

    context 'with invalid attributes' do
      let(:invalid_order) do
        FactoryBot.attributes_for(
          :order,
          delivery_address: 'Gulshan, Dhaka',
          user_id: 0,
          total_bill: 0.0,
          order_status: '',
        )
      end

      let(:create_actions) { post :create, params: { order: invalid_order } }

      it 'shows flash message for failure creation' do
        create_actions

        expect(flash[:error]).to eq(I18n.t('notice.create.fail', resource: Order.model_name.human))
      end

      it 'does not create a new order into database' do
        expect { create_actions }.to change(Order, :count).by(0)
      end
    end
  end

  context 'with nested attributes' do
    context 'with valid nested attributes order_item' do
      let(:valid_order_item_params) do
        FactoryBot.attributes_for(:order_item, book_id: book.id, quantity: 1)
      end

      let(:order_params) do
        FactoryBot.attributes_for(
          :order,
          user_id: user.id,
          total_bill: 100,
          delivery_address: 'Jahurul Islam Ave, Dhaka',
          order_status: :pending,
          order_items_attributes: [valid_order_item_params],
        )
      end

      let(:create_action) { post :create, params: { order: order_params } }

      it 'accepts and saves order_item in database' do
        expect { create_action }.to change(OrderItem, :count).by(1)
      end

      it 'redirects to book index path' do
        expect(create_action).to redirect_to books_path
      end

      it 'shows flash message for successful creation' do
        create_action

        expect(flash[:success]).to eq(I18n.t('notice.create.success', resource: Order.model_name.human))
      end
    end
    context 'with invalid nested attributes' do
      let(:invalid_order_item_params) do
        FactoryBot.attributes_for(:order_item, quantity: 0, book_id: book.id)
      end

      let(:order_params) do
        FactoryBot.attributes_for(
          :order,
          user_id: user.id,
          delivery_address: 'Ave, Dhaka',
          total_bill: 0.0,
          order_status: :pending,
          order_items_attributes: [invalid_order_item_params],
        )
      end

      let(:create_action) { post :create, params: { order: order_params } }

      it 'does not save order_item into database' do
        expect { create_action }.not_to change(OrderItem, :count)
      end

      it 'shows flash message for failure case' do
        create_action

        expect(flash[:error]).to eq('Order Creation Failed!')
      end
    end
  end

  describe 'GET #edit' do
    context 'with valid attibutes' do
      before { get :edit, params: { id: order_1.id } }

      it { is_expected.to render_template(:edit) }
      it { is_expected.to respond_with(:success) }

      it 'assigns the order to @order' do
        expect(assigns(:order)).to eq(order_1)
      end
    end

    context 'with  invalid attributes' do
      before { get :edit, params: { id: 0 } }

      it { is_expected.to set_flash.to(I18n.t('notice.not_found', resource: Order.model_name.human)) }
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      let(:new_params) do
        FactoryBot.attributes_for(
          :order,
          delivery_address: 'Nuruzzaman Rd, Dhaka',
          order_status: :placed,
        )
      end

      before { patch :update, params: { id: order_1.id, order: new_params } }

      it { is_expected.to redirect_to order_path }

      it 'updates the deslivery address' do
        order_1.reload

        expect(order_1.delivery_address).to eq('Nuruzzaman Rd, Dhaka')
      end

      it 'shows flash message for update successfully' do
        order_1.reload

        expect(flash[:notice]).to eq(I18n.t('notice.update.success', resource: Order.model_name.human))
      end
    end

    context 'with invalid attributes' do
      let(:new_params) do
        FactoryBot.attributes_for(
          :order,
          user_id: nil,
          order_status: nil,
        )
      end

      before { patch :update, params: { id: order_1.id, order: new_params } }

      it { is_expected.to render_template(:edit) }

      it 'shows flash message for failure case' do
        expect(flash[:error]).to eq(I18n.t('notice.update.fail', resource: Order.model_name.human))
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid attributes' do
      let(:delete_action) { delete :destroy, params: { id: order_2.id } }

      it 'deletes the order from the database' do
        expect { delete_action }.to change(Order, :count).by(-1)
      end

      it 'shows flash message for delete successfully' do
        delete_action

        expect(flash[:success]).to eq(I18n.t('notice.delete.success', resource: Order.model_name.human))
      end

      it 'redirects to order index path' do
        delete_action

        expect(response).to redirect_to orders_path
      end
    end

    context 'with invalid attributes' do
      let(:delete_action) { delete :destroy, params: { id: 0 } }

      it 'shows flash message for failure case' do
        delete_action

        expect(flash[:error]).to eq(I18n.t('notice.not_found', resource: Order.model_name.human))
      end

      it 'does not delete order from database' do
        expect { delete_action }.not_to change(Order, :count)
      end
    end
  end
end
