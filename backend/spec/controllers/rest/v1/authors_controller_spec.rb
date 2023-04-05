require 'rails_helper'

# Renamed it as 'Rest' to keep the REST and Grape both API
# implementation intact in the project
# because this project is developed for learning purpose
RSpec.describe Rest::V1::AuthorsController do
  let!(:author_1) { FactoryBot.create(:author) }
  let(:author_1_id) { author_1.id }
  let!(:author_2) { FactoryBot.create(:author) }

  describe 'GET #index' do
    before { get :index }

    it 'returns content' do
      result = JSON.parse(response.body)

      expect(result['author']['data'].length).to eq(2)
    end

    it 'returns status ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    context 'when the record exists' do
      before { get :show, params: { id: author_1_id } }

      it 'returns valid author' do
        result = JSON.parse(response.body)

        expect(result['author']['data']['id'].to_i).to eq(author_1_id)
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when record does not exist' do
      before { get :show, params: { id: 0 } }

      it { is_expected.to rescue_from(ActiveRecord::RecordNotFound) }
    end
  end

  describe 'POST #create' do
    context 'with valid author' do
      let(:author_params) { FactoryBot.attributes_for(:author) }
      let(:create_action) { post :create, params: { author: author_params } }

      it 'creates a new author' do
        expect { create_action }.to change(Author, :count).by(1)
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid author' do
      let(:author_params) { FactoryBot.attributes_for(:author, full_name: '') }
      let(:create_action) { post :create, params: { author: author_params } }

      it 'does not create author into database' do
        expect { create_action }.to_not change(Author, :count)
      end

      it 'returns status bad_request' do
        create_action

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error message' do
        create_action

        expect(response.body).to match('Unable to create Author.')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid author' do
      let(:valid_author_params) { { full_name: 'JK Rowling' } }
      let(:update_action) { patch :update, params: { id: author_1_id, author: valid_author_params } }

      it 'updates the authors full_name' do
        update_action
        author_1.reload

        expect(author_1.full_name).to eq('JK Rowling')
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_action) { delete :destroy, params: { id: author_1_id } }

    it 'deletes the author' do
      expect { delete_action }.to change(Author, :count).by(-1)
    end

    it 'returns status ok' do
      expect(response).to have_http_status(:ok)
    end
  end
end
