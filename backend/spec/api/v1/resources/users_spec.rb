require 'rails_helper'

RSpec.describe API::V1::Resources::Users do
  let!(:user_1) { FactoryBot.create(:user) }
  let!(:user_2) { FactoryBot.create(:user) }
  let(:request_url) { '/api/v1/users' }

  describe 'Get /users' do
    context 'with valid attributes' do
      let(:users) { User.all }
      let(:users_entity) { API::V1::Entities::User.represent(users) }
      before { get request_url }

      it 'returns 200 ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the users list' do
        expect(JSON.parse(response.body).size).to eq(2)
        expect(JSON.parse(response.body)).to match_array(JSON.parse(users_entity.to_json))
      end
    end
  end

  describe 'GET /users/:id' do
    context 'with valid user id' do
      before { get request_url + "/#{user_1.id}" }

      it 'returns 200 ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'gets a specific user by id' do
        expect(JSON.parse(response.body)).to eq(JSON.parse(user_1.to_json))
      end
    end

    context 'with invalid user id' do
      let(:error_message) do
        {
          'message' => "Couldn't find User with 'id'=0",
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

  describe 'POST /users' do
    context 'with valid params' do
      let(:valid_params) do
        {
          'user':
            {
              'name': 'Neha',
              'email': 'neha@gmail.com',
              'password': '123456',
              'phone': '01709876577',
              'role': 'admin',
            },
        }
      end

      let(:create_action) { post request_url, params: valid_params }

      it 'returns 201 created status' do
        create_action

        expect(response).to have_http_status(:created)
      end

      it 'creates a user' do
        expect { create_action }.to change(User, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) do
        {
          'user':
            {
              'name': 'Neha Sharma',
              'password': '123456',
              'phone': '01709876577',
              'role': 0,
            },
        }
      end
      let(:error_message) do
        {
          'message' => 'user[email] is missing, user[email] is empty',
        }
      end

      let(:create_action) { post request_url, params: invalid_params }

      it 'returns 400 bad request status' do
        create_action

        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create a user' do
        expect { create_action }.to change(User, :count).by(0)
      end

      it 'returns response message' do
        create_action

        expect(JSON.parse(response.body)).to eq(error_message)
      end
    end
  end

  describe 'PATCH /users/:id' do
    context 'with valid attributes' do
      let(:valid_update_params) do
        {
          'user': { 'name': 'Kobir', 'password': user_1.password },
        }
      end

      let(:update_action) { patch request_url + "/#{user_1.id}", params: valid_update_params }

      it 'returns 200 ok status' do
        update_action

        expect(response).to have_http_status(:ok)
      end

      it 'updates a user' do
        update_action

        expect(user_1.reload.name).to eq('Kobir')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_user) do
        {
          'user': { 'email': 'Worng.com', 'password': '123456' },
        }
      end
      let(:error_message) do
        {
          'message' => 'user[email] is invalid',
        }
      end

      let(:update_action) { patch request_url + "/#{user_1.id}", params: invalid_user }

      it 'returns 400 bad request status' do
        update_action

        expect(response).to have_http_status(:bad_request)
      end

      it 'does not update the user' do
        update_action

        expect(JSON.parse(response.body)).to eq(error_message)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid user' do
      let(:delete_action) { delete request_url + "/#{user_1.id}" }

      it 'returns 200 ok status' do
        delete_action

        expect(response).to have_http_status(:ok)
      end

      it 'deletes an user' do
        expect { delete_action }.to change(User, :count).by(-1)
      end
    end

    context 'with invalid user id' do
      let(:error_message) do
        {
          'message' => "Couldn't find User with 'id'=0",
        }
      end

      let(:delete_action) { delete request_url + '/0' }

      it 'returns 404 not_found status' do
        delete_action

        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        delete_action

        expect(JSON.parse(response.body)).to eq(error_message)
      end
    end
  end
end
