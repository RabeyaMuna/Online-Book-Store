require 'rails_helper'

RSpec.describe API::V1::Resources::Genres do
  let!(:genre_1) { FactoryBot.create(:genre) }
  let!(:genre_2) { FactoryBot.create(:genre) }
  let(:genre_1_entity) { API::V1::Entities::Genre.represent(genre_1) }
  let(:request_url) { '/api/v1/genres' }

  describe 'GET /genres' do
    let(:genres_entity) { API::V1::Entities::Genre.represent(Genre.all) }
    before { get request_url }

    it 'returns success status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the genres list' do
      expect(JSON.parse(response.body).size).to eq(2)
    end

    it 'returns an array of genres' do
      expect(JSON.parse(response.body)).to match_array(JSON.parse(genres_entity.to_json))
    end
  end

  describe 'GET /genres/:id' do
    context 'with valid genre id' do
      before { get request_url + "/#{genre_1.id}" }

      it 'returns success status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a specific genre' do
        expect(JSON.parse(response.body)).to match_array(JSON.parse(genre_1_entity.to_json))
      end
    end

    context 'with invalid genre id' do
      before { get request_url + '/0' }

      it 'returns error status code' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(JSON.parse(response.body)['message']).to eq("Couldn't find Genre with 'id'=0")
      end
    end
  end

  describe 'POST /genres' do
    context 'with valid attributes' do
      let(:valid_genre) { { 'genre': { 'name': 'The Newspaper Dog' } } }
      let(:create_action) { post request_url, params: valid_genre }

      it 'creates a new genre' do
        expect { create_action }.to change(Genre, :count).by(1)
      end

      it 'returns success status code' do
        create_action

        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'PATCH /genres/:id' do
    context 'with valid attributes' do
      let(:new_params) { { 'genre': { 'name': 'New Name' } } }
      let(:genre_1_entity_2) { API::V1::Entities::Genre.represent(genre_1.reload) }

      before { patch request_url + "/#{genre_1.id}", params: new_params }

      it 'updates the genre' do
        expect(genre_1.reload.name).to eq('New Name')
      end

      it 'returns success status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a specific genre' do
        expect(JSON.parse(response.body)).to eq(JSON.parse(genre_1_entity_2.to_json))
      end
    end

    context 'with invalid attributes' do
      let(:invalid_genre) { { 'genre': { 'name': '' } } }

      before { patch request_url + "/#{genre_1.id}", params: invalid_genre }

      it 'returns unprocessable status code' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE /genres/:id' do
    context 'with valid attributes' do
      let(:delete_action) { delete request_url + "/#{genre_1.id}" }

      it 'deletes a genre' do
        expect { delete_action }.to change(Genre, :count).by(-1)
      end

      it 'returns success status' do
        delete_action

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      let(:error_message) { { 'message' => 'Record Not Found' } }
      let(:delete_action) { delete request_url + '/0' }

      it 'does not delete a genre' do
        expect { delete_action }.to_not change(Genre, :count)
      end

      it 'returns error status' do
        delete_action

        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        delete_action

        expect(JSON.parse(response.body)['message']).to eq("Couldn't find Genre with 'id'=0")
      end
    end
  end
end
