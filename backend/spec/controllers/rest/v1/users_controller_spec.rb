require 'rails_helper'

# Reamed it as 'Rest' to keep the REST and Grape both API
# implementation intact in the project
# because this project is developed for learning purpose
RSpec.describe Rest::V1::UsersController do
  let!(:user_1) { FactoryBot.create(:user, name: 'Karim') }
  let!(:user_2) { FactoryBot.create(:user, name: 'Rahim') }
  let(:result) { UserSerializer.new(user_1).serializable_hash }

  describe 'GET #index' do
    before { get :index, format: :json }

    it 'returns success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns content' do
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['data'].size).to eq(2)
    end

    it 'returns status ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    context 'when the record exists' do
      before { get :show, params: { id: user_1.id } }

      it 'returns valid user' do
        result = JSON.parse(response.body)

        expect(result['data']['id'].to_i).to eq(user_1.id)
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
    context 'with valid user' do
      let(:create_action) { post :create, params: { user: FactoryBot.attributes_for(:user) } }

      it 'creates a new user' do
        expect { create_action }.to change(User, :count).by(1)
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid user' do
      let(:create_action) { post :create, params: { user: FactoryBot.attributes_for(:user, name: '') } }

      it 'does not create user into database' do
        expect { create_action }.not_to change(User, :count)
      end

      it 'returns status bad_request' do
        create_action

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error message' do
        create_action

        expect(response.body).to match('Unable to create User.')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid user attributes' do
      before do
        patch :update, params: { id: user_1.id, user: FactoryBot.attributes_for(:user, name: 'New Name') }
      end

      it 'updates the name' do
        expect(user_1.reload.name).to eq('New Name')
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid user attributes' do
      let(:attributes) { FactoryBot.attributes_for(:user, email: 'invalid email') }
      before { patch :update, params: { id: user_1.id, user: attributes } }

      it 'does not update the email' do
        expect(user_1.reload.email).to_not eq('invalid email')
      end

      it 'returns status bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error message' do
        user_1.reload

        expect(response.body).to match('Unable to update user.')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid data' do
      let(:delete_action) { delete :destroy, params: { id: user_1.id } }

      it 'deletes the user' do
        expect { delete_action }.to change(User, :count).by(-1)
      end

      it 'returns success message' do
        delete_action

        expect(response.body).to match('Deleted the user')
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid data' do
      let(:delete_action) { delete :destroy, params: { id: 0 } }

      it 'does not delete user from database' do
        expect { delete_action }.not_to change(User, :count)
      end

      it 'rescues invalid exception' do
        delete_action

        is_expected.to rescue_from(ActiveRecord::RecordNotFound)
      end
    end
  end
end
