require 'rails_helper'

RSpec.describe Rest::V1::GenresController do
  let!(:genre) { FactoryBot.create(:genre) }

  let(:expected_hash) do
    {
      'id' => genre.id.to_s,
      'type' => 'genre',
      'attributes' => { 'name' => genre.name },
      'relationships' =>
      {
        'books' => { 'data' => [] },
        'book_genres' => { 'data' => [] },
      },
    }
  end

  describe 'GET #index' do
    before { get :index }

    it 'lists all Genre' do
      body = JSON.parse(response.body)
      expect(body['data']['data'][0]).to eq(expected_hash)
    end

    it 'returns status ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    context 'when the record exists' do
      before { get :show, params: { id: genre.id } }

      it 'returns valid genre' do
        body = JSON.parse(response.body)

        expect(body['data']['data']['id'].to_i).to eq(genre.id)
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
    context 'with valid genre' do
      let(:genre_params) { FactoryBot.attributes_for(:genre) }
      let(:create_action) { post :create, params: { genre: genre_params } }

      it 'creates a new genre' do
        expect { create_action }.to change(Genre, :count).by(1)
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns success message' do
        create_action

        expect(response.body).to match('Genre Created Successfully!')
      end
    end

    context 'with invalid genre' do
      let(:genre_params) { FactoryBot.attributes_for(:genre, name: '') }
      let(:create_action) { post :create, params: { genre: genre_params } }

      it 'does not create genre into database' do
        expect { create_action }.to_not change(Genre, :count)
      end

      it 'returns status bad request' do
        create_action

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error message' do
        create_action

        expect(response.body).to match('Genre Creation Failed!')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid genre' do
      let(:valid_genre_params) { { name: 'Short story' } }
      let(:update_action) { patch :update, params: { id: genre.id, genre: valid_genre_params } }

      it 'updates the genres name' do
        update_action

        expect(genre.reload.name).to eq('Short story')
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_action) { delete :destroy, params: { id: genre.id } }

    it 'deletes the genre' do
      expect { delete_action }.to change(Genre, :count).by(-1)
    end

    it 'returns status ok' do
      expect(response).to have_http_status(:ok)
    end
  end
end
