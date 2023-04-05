require 'rails_helper'

RSpec.describe RegistrationsController do
  describe 'GET #new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_params) { FactoryBot.attributes_for(:user, role: 'user') }
      let(:create_action) { post :create, params: { user: valid_params } }

      it 'creates a new user' do
        expect { create_action }.to change(User, :count).by(1)
      end

      it 'enqueues the mailer job' do
        expect { create_action }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
      end

      it 'redirects to sign in page' do
        create_action

        expect(response).to redirect_to(sign_in_path)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) { FactoryBot.attributes_for(:user, name: '') }
      let!(:create_action) { post :create, params: { user: invalid_params } }

      it 'does not create a new user' do
        expect { create_action }.to_not change(User, :count)
      end

      it { is_expected.to render_template(:new) }
    end
  end
end
