require 'rails_helper'

RSpec.describe Rest::V1::BooksController do
  let(:user) { FactoryBot.create(:user, role: 'admin') }
  let!(:book_1) { FactoryBot.create(:book, name: 'Alice in Wonderland') }

  before { sign_in_as user }

  describe 'GET #index' do
    before { get :index, format: :json }

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns valid JSON' do
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['data'].size).to eq(1)
    end
  end

  describe 'GET #show' do
    context 'with valid attributes' do
      before { get :show, params: { id: book_1.id } }

      it 'returns valid author' do
        result = JSON.parse(response.body)
        expect(result['data']['id'].to_i).to eq(book_1.id)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      before { get :show, params: { id: 0 } }

      it { is_expected.to rescue_from(ActiveRecord::RecordNotFound) }
    end
  end

  describe 'POST #create' do
    context 'with valid input' do
      let(:book_params) { FactoryBot.attributes_for(:book) }
      let(:create_action) { post :create, params: { book: book_params } }

      it 'creates a new book' do
        expect { create_action }.to change(Book, :count).by(1)
      end
    end

    context 'with invalid input' do
      let(:invalid_book_params) { FactoryBot.attributes_for(:book, name: '') }
      let(:create_action) { post :create, params: { book: invalid_book_params } }

      it 'does not create a book' do
        expect { create_action }.to_not change(Book, :count)
      end

      it 'returns error message' do
        create_action

        expect(response.body).to match('Unable to create book.')
      end

      it 'returns http response' do
        create_action

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      let(:new_params) { FactoryBot.attributes_for(:book, name: 'Some Book') }

      before { patch :update, params: { id: book_1.id, book: new_params } }

      it 'updates the name of the book' do
        expect(book_1.reload.name).to eq('Some Book')
      end

      it 'returns success message' do
        expect(response.body).to match('Book successfully updated.')
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      let(:new_params) { FactoryBot.attributes_for(:book, name: '') }

      before { patch :update, params: { id: book_1.id, book: new_params } }

      it 'returns http success' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error message' do
        expect(response.body).to match('Unable to update Book.')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid attributes' do
      let(:delete_action) { delete :destroy, params: { id: book_1.id } }

      it 'deletes a book from' do
        expect { delete_action }.to change(Book, :count).by(-1)
      end

      it 'flashes success message' do
        delete_action

        expect(response.body).to match('Book successfully deleted.')
      end
    end

    context 'with invalid attributes' do
      let(:delete_action) { delete :destroy, params: { id: 0 } }

      it 'does not delete a book from the database' do
        expect { delete_action }.not_to change(Book, :count)
      end

      it 'rescues invalid exception' do
        delete_action

        is_expected.to rescue_from(ActiveRecord::RecordNotFound)
      end
    end
  end
end
