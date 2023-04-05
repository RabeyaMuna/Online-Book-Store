require 'rails_helper'

RSpec.describe API::V1::Resources::Books do
  let!(:book_1) { FactoryBot.create(:book) }
  let!(:book_2) { FactoryBot.create(:book) }
  let(:book_1_entity) { API::V1::Entities::Book.represent(book_1) }
  let(:request_url) { '/api/v1/books' }

  describe 'GET /books' do
    let(:books_entity) { API::V1::Entities::Book.represent(Book.all) }
    before { get request_url }

    it 'returns success status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the books list' do
      expect(JSON.parse(response.body).size).to eq(2)
    end

    it 'returns an array of books' do
      expect(JSON.parse(response.body)).to match_array(JSON.parse(books_entity.to_json))
    end
  end

  describe 'GET /books/:id' do
    context 'with valid book id' do
      before { get request_url + "/#{book_1.id}" }

      it 'returns success status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a specific book' do
        expect(JSON.parse(response.body)).to match_array(JSON.parse(book_1_entity.to_json))
      end
    end

    context 'with invalid book id' do
      before { get request_url + '/0' }

      it 'returns error status code' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(JSON.parse(response.body)['message']).to eq("Couldn't find Book with 'id'=0")
      end
    end
  end

  describe 'POST /books' do
    context 'with valid attributes' do
      let(:valid_book) do
        {
          "book":
          {
            "name": 'The Newspaper Dog',
            "price": 350,
            "total_copies": 101,
          },
        }
      end

      let(:create_action) { post request_url, params: valid_book }

      it 'creates a new book' do
        expect { create_action }.to change(Book, :count).by(1)
      end

      it 'returns success status code' do
        create_action

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_book) do
        {
          "book":
          {
            "name": 'Book one',
          },
        }
      end

      let(:error_message) do
        {
          'message' => 'book[price] is missing, book[total_copies] is missing',
        }
      end

      let(:create_action) { post request_url, params: invalid_book }

      it 'does not create a book' do
        expect { create_action }.to_not change(Book, :count)
      end

      it 'returns response message' do
        create_action

        expect(JSON.parse(response.body)).to eq(error_message)
      end

      it 'returns unprocessable status code' do
        create_action

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PATCH /books/:id' do
    context 'with valid attributes' do
      let(:new_params) do
        {
          "book":
          {
            "name": 'New Name',
          },
        }
      end

      before { patch request_url + "/#{book_1.id}", params: new_params }
      let(:book_1_entity_2) { API::V1::Entities::Book.represent(book_1.reload) }

      it 'updates the book' do
        expect(book_1.reload.name).to eq('New Name')
      end

      it 'returns success status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a specific book' do
        expect(JSON.parse(response.body)).to eq(JSON.parse(book_1_entity_2.to_json))
      end
    end

    context 'with invalid attributes' do
      let(:invalid_book) do
        {
          "book":
          {
            "name": '',
          },
        }
      end

      before { patch request_url + "/#{book_1.id}", params: invalid_book }

      it 'returns unprocessable status code' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE /books/:id' do
    context 'with valid attributes' do
      let(:delete_action) { delete request_url + "/#{book_1.id}" }

      it 'deletes a book' do
        expect { delete_action }.to change(Book, :count).by(-1)
      end

      it 'returns success status' do
        delete_action

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      let(:error_message) do
        {
          'message' => 'Record Not Found',
        }
      end

      let(:delete_action) { delete request_url + '/0' }

      it 'does not delete a book' do
        expect { delete_action }.to_not change(Book, :count)
      end

      it 'returns error status' do
        delete_action

        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        delete_action

        expect(JSON.parse(response.body)['message']).to eq("Couldn't find Book with 'id'=0")
      end
    end
  end
end
