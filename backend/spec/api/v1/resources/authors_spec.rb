require 'rails_helper'

RSpec.describe API::V1::Resources::Authors do
  let!(:author_1) { FactoryBot.create(:author, full_name: 'JK Rowling') }
  let!(:author_2) { FactoryBot.create(:author, full_name: 'Zahir Raihan') }
  let(:request_url) { '/api/v1/authors' }

  describe 'GET /authors' do
    context 'with valid attributes' do
      let(:authors) { Author.all }
      let(:authors_entity) { API::V1::Entities::Author.represent(authors) }
      before { get request_url }

      it 'returns 200 ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the authors list' do
        expect(JSON.parse(response.body).size).to eq(2)
        expect(JSON.parse(response.body)).to match_array(JSON.parse(authors_entity.to_json))
      end
    end
  end

  describe 'GET /authors/:id' do
    context 'with valid attributes' do
      before { get request_url + "/#{author_1.id}" }

      it 'returns 200 ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a specific author with success status' do
        expect(JSON.parse(response.body)).to match_array(JSON.parse(author_1.to_json))
      end
    end

    context 'with invalid attributes' do
      let(:error_message) do
        {
          'message' => "Couldn't find Author with 'id'=0",
        }
      end

      before { get request_url + '/0' }

      it 'returns 404 not_found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(JSON.parse(response.body)).to eq(error_message)
      end
    end
  end

  describe 'POST /authors' do
    context 'with valid attributes' do
      let(:valid_author) do
        {
          'author':
          {
            'full_name': 'Haruki Murakami',
            'nick_name': 'Natsu',
            'biography': 'Intelligentsia wayfarers brooklyn retro.',
          },
        }
      end

      let(:create_action) { post request_url, params: valid_author }

      it 'returns 201 created status' do
        create_action
        expect(response).to have_http_status(:created)
      end

      it 'creates an author' do
        expect { create_action }.to change(Author, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_author) do
        {
          'author':
          {
            'full_name': 'Haruki Murakami',
            'biography': 'He is a Japanese writer.',
          },
        }
      end
      let(:error_message) do
        {
          'message' => 'author[nick_name] is missing, author[nick_name] is empty',
        }
      end

      let(:create_action) { post request_url, params: invalid_author }

      it 'returns 400 unprocessable_entity status' do
        create_action
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error message' do
        expect { create_action }.to change(Author, :count).by(0)
        expect(JSON.parse(response.body)).to eq(error_message)
      end
    end
  end

  describe 'PATCH /authors/:id' do
    context 'with valid attributes' do
      let(:new_params) do
        {
          'author':
          {
            'full_name': 'New Name',
          },
        }
      end

      before { patch request_url + "/#{author_1.id}", params: new_params }

      it 'returns 200 ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates an author' do
        expect(author_1.reload.full_name).to eq('New Name')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_author) do
        {
          'author':
          {
            'full_name': '',
          },
        }
      end
      let(:error_message) do
        {
          'message' => 'author[full_name] is empty',
        }
      end

      before { patch request_url + "/#{author_1.id}", params: invalid_author }

      it 'returns 400 unprocessable_entity status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error message with status' do
        expect(JSON.parse(response.body)).to eq(error_message)
      end
    end

    describe 'DELETE /authors/:id' do
      context 'with valid attributes' do
        let(:delete_action) { delete request_url + "/#{author_1.id}" }

        it 'returns 200 ok status' do
          delete_action
          expect(response).to have_http_status(:ok)
        end

        it 'deletes an author' do
          expect { delete_action }.to change(Author, :count).by(-1)
        end
      end

      context 'with invalid attributes' do
        let(:error_message) do
          {
            'message' => "Couldn't find Author with 'id'=0",
          }
        end

        before { delete request_url + '/0' }

        it 'returns 404 not_found status' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns error message' do
          expect(JSON.parse(response.body)).to eq(error_message)
        end
      end
    end
  end
end
