require 'rails_helper'

RSpec.describe UsersController do
  let!(:user_1) { FactoryBot.create(:user, name: 'Karim', role: 'user') }
  let!(:admin_1) { FactoryBot.create(:user, name: 'Rahim', role: 'admin') }
  let!(:guest_1) { nil }

  describe 'GET #index' do
    context 'Signed in as Admin' do
      before { sign_in_as admin_1 }
      before { get :index }

      it { is_expected.to render_template(:index) }
      it { is_expected.to respond_with(:success) }

      it 'assigns all users into User' do
        expect(assigns(:users)).to match_array([user_1, admin_1])
      end
    end

    context 'Signed in as User' do
      before { sign_in_as user_1 }
      before { get :index }

      it { is_expected.to_not render_template(:index) }
      it { is_expected.to respond_with(302) }
    end

    context 'Not signed in - Guest User' do
      before { get :index }

      it { is_expected.to_not render_template(:index) }
      it { is_expected.to respond_with(302) }
      it { is_expected.to set_flash.to('Please sign in to continue.') }
    end
  end

  describe 'GET #show' do
    context 'Signed in as Admin' do
      before { sign_in_as admin_1 }

      context 'with valid attributes' do
        before { get :show, params: { id: user_1.id } }

        it { is_expected.to render_template(:show) }
        it { is_expected.to respond_with(:success) }
      end

      context 'with invalid attributes' do
        before { get :show, params: { id: 0 } }

        it { is_expected.to set_flash.to(I18n.t('notice.not_found', resource: User.model_name.human)) }
      end
    end

    context 'Signed in as User' do
      before { sign_in_as user_1 }

      context 'with valid attributes of self' do
        before { get :show, params: { id: user_1.id } }

        it { is_expected.to render_template(:show) }
        it { is_expected.to respond_with(:success) }
      end

      context 'with valid attributes of other users' do
        before { get :show, params: { id: 1 } }

        it { is_expected.to_not render_template(:show) }
        it { is_expected.to respond_with(302) }
      end

      context 'with valid attributes of other user' do
        before { get :show, params: { id: admin_1.id } }

        it { is_expected.to_not render_template(:show) }
        it { is_expected.to respond_with(302) }
      end

      context 'with invalid attributes' do
        before { get :show, params: { id: 0 } }

        it { is_expected.to set_flash.to(I18n.t('notice.not_found', resource: User.model_name.human)) }
      end
    end

    context 'Not signed in - Guest User' do
      context 'with valid attributes' do
        before { get :show, params: { id: user_1.id } }

        it { is_expected.to_not render_template(:show) }
        it { is_expected.to respond_with(302) }
        it { is_expected.to set_flash.to('Please sign in to continue.') }
      end

      context 'with invalid attributes' do
        before { get :show, params: { id: 0 } }

        it { is_expected.to set_flash.to('Please sign in to continue.') }
      end
    end
  end

  describe 'GET #new' do
    before { get :new }

    context 'Signed in as Admin' do
      before { sign_in_as admin_1 }
      before { get :new }

      it { is_expected.to render_template(:new) }
      it { is_expected.to respond_with(:success) }

      it 'assigns a new user to @user' do
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    context 'Signed in as User' do
      before { sign_in_as user_1 }
      before { get :new }

      it { is_expected.to_not render_template(:new) }
    end

    context 'Not signed in - Guest User' do
      before { get :new }

      it { is_expected.to_not render_template(:new) }
      it { is_expected.to respond_with(302) }
      it { is_expected.to set_flash.to('Please sign in to continue.') }
    end
  end

  describe 'POST #create' do
    context 'Signed in as Admin' do
      before { sign_in_as admin_1 }

      context 'with valid attributes' do
        let(:create_action) { post :create, params: { user: FactoryBot.attributes_for(:user) } }

        it 'redirects to index' do
          expect(create_action).to redirect_to(action: :index)
        end

        it 'flashes success message' do
          create_action

          expect(flash[:success]).to eq(I18n.t('notice.create.success', resource: User.model_name.human))
        end

        it 'create a new user in users table' do
          expect { create_action }.to change(User, :count)
        end
      end

      context 'with invalid attributes' do
        let(:create_action) { post :create, params: { user: FactoryBot.attributes_for(:user, name: '') } }

        it 'shows error message' do
          create_action

          expect(flash[:error]).to eq(I18n.t('notice.create.fail', resource: User.model_name.human))
        end

        it 'renders edit template' do
          expect(create_action).to_not render_template(:edit)
        end

        it 'does not create a new user in users table' do
          expect { create_action }.to_not change(User, :count)
        end
      end
    end

    context 'Signed in as User' do
      before { sign_in_as user_1 }

      context 'with valid attributes' do
        let(:create_action) { post :create, params: { user: FactoryBot.attributes_for(:user) } }

        it 'does not flash success message' do
          create_action

          expect(flash[:success]).to_not eq(I18n.t('notice.create.success', resource: User.model_name.human))
        end

        it 'does not create a new user in users table' do
          expect { create_action }.not_to change(User, :count)
        end
      end

      context 'with invalid attributes' do
        let(:create_action) { post :create, params: { user: FactoryBot.attributes_for(:user, name: '') } }

        it 'shows error message' do
          create_action

          expect(flash[:error]).to_not eq(I18n.t('notice.create.fail', resource: User.model_name.human))
        end

        it 'renders edit template' do
          expect(create_action).to_not render_template(:new)
        end

        it 'does not create a new user in users table' do
          expect { create_action }.to_not change(User, :count)
        end
      end
    end

    context 'Not signed in - Guest User' do
      before { get :new }

      it { is_expected.to_not render_template(:new) }
      it { is_expected.to respond_with(302) }
      it { is_expected.to set_flash.to('Please sign in to continue.') }
    end
  end

  describe 'GET #edit' do
    context 'Signed in as Admin' do
      before { sign_in_as admin_1 }

      context 'with valid attributes' do
        before { get :edit, params: { id: user_1.id } }

        it { is_expected.to_not render_template(:edit) }
      end

      context 'with invalid attributes' do
        before { get :edit, params: { id: 0 } }

        it { is_expected.to set_flash.to(I18n.t('notice.not_found', resource: User.model_name.human)) }
      end
    end

    context 'Signed in as User' do
      before { sign_in_as user_1 }

      context 'with valid attributes' do
        before { get :edit, params: { id: user_1.id } }

        it { is_expected.to render_template(:edit) }
        it { is_expected.to respond_with(:success) }
      end

      context 'with invalid attributes' do
        before { get :edit, params: { id: 0 } }

        it { is_expected.to set_flash.to(I18n.t('notice.not_found', resource: User.model_name.human)) }
      end
    end

    context 'Not signed in - Guest User' do
      context 'with valid attributes' do
        before { get :edit, params: { id: user_1.id } }

        it { is_expected.to_not render_template(:edit) }
        it { is_expected.to set_flash.to('Please sign in to continue.') }
      end
    end
  end

  describe 'PATCH #update' do
    context 'Signed in as Admin' do
      before { sign_in_as admin_1 }

      context 'with valid attributes' do
        before do
          patch :update, params: { id: user_1.id, user: FactoryBot.attributes_for(:user, name: 'New Name') }
        end

        it { is_expected.to_not redirect_to(action: :index) }
        it {
          is_expected.to_not set_flash.to(I18n.t('notice.update.success', resource: User.model_name.human))
        }
      end

      context 'with invalid attributes' do
        let(:attributes) { FactoryBot.attributes_for(:user, email: 'invalid email') }
        before { patch :update, params: { id: user_1.id, user: attributes } }

        it { is_expected.to_not render_template(:edit) }
        it { is_expected.to_not set_flash.to(I18n.t('notice.update.fail', resource: User.model_name.human)) }
      end
    end

    context 'Signed in as User' do
      before { sign_in_as user_1 }

      context 'with valid attributes' do
        before do
          patch :update, params: { id: user_1.id, user: FactoryBot.attributes_for(:user, name: 'New Name') }
        end

        it { is_expected.to redirect_to(action: :index) }
        it { is_expected.to set_flash.to(I18n.t('notice.update.success', resource: User.model_name.human)) }

        it 'updates the name' do
          expect(user_1.reload.name).to eq('New Name')
        end
      end

      context 'with invalid attributes' do
        let(:attributes) { FactoryBot.attributes_for(:user, email: 'invalid email') }
        before { patch :update, params: { id: user_1.id, user: attributes } }

        it { is_expected.to render_template(:edit) }
        it { is_expected.to set_flash.to(I18n.t('notice.update.fail', resource: User.model_name.human)) }

        it 'does not update the email' do
          expect(user_1.reload.email).to_not eq('invalid email')
        end
      end
    end

    context 'Not signed in - Guest User' do
      context 'with valid attributes' do
        before do
          patch :update, params: { id: user_1.id, user: FactoryBot.attributes_for(:user, name: 'New Name') }
        end

        it { is_expected.to_not redirect_to(action: :index) }
        it { is_expected.to set_flash.to('Please sign in to continue.') }
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Signed in as Admin' do
      before { sign_in_as admin_1 }

      context 'with valid attributes' do
        let(:delete_action) { delete :destroy, params: { id: user_1.id } }

        it 'shows confirmation message' do
          delete_action

          expect(flash[:success]).to eq(I18n.t('notice.delete.success', resource: User.model_name.human))
        end

        it 'redirects to index action' do
          expect(delete_action).to redirect_to(action: :index)
        end

        it 'deletes a user from users table' do
          expect { delete_action }.to change(User, :count)
        end
      end

      context 'with invalid attributes' do
        let(:delete_action) { delete :destroy, params: { id: 0 } }

        it 'shows error message' do
          delete_action

          expect(flash[:error]).to eq(I18n.t('notice.not_found', resource: User.model_name.human))
        end

        it 'does not delete a user from users table' do
          expect { delete_action }.to_not change(User, :count)
        end
      end
    end

    context 'Signed in as User' do
      before { sign_in_as user_1 }

      context 'with valid attributes' do
        let(:delete_action) { delete :destroy, params: { id: user_1.id } }

        it 'does not show confirmation message' do
          delete_action

          expect(flash[:success]).to_not eq(I18n.t('notice.delete.success', resource: User.model_name.human))
        end

        it 'does not delete a user from users table' do
          expect { delete_action }.to_not change(User, :count)
        end
      end

      context 'with invalid attributes' do
        let(:delete_action) { delete :destroy, params: { id: 0 } }

        it 'does not delete a user from users table' do
          expect { delete_action }.to_not change(User, :count)
        end
      end
    end

    context 'Not signed in - Guest User' do
      let(:delete_action) { delete :destroy, params: { id: user_1.id } }

      it 'does not delete a user from users table' do
        expect { delete_action }.to_not change(User, :count)
      end
    end
  end

  describe 'Pagination' do
    before do
      4.times { FactoryBot.create(:user) }
    end

    context 'Signed in as Admin' do
      before { sign_in_as admin_1 }

      it 'paginates record on first page with no page param specified' do
        get :index

        expect(assigns(:users).count).to eq(5)
      end

      it 'paginates record on first page' do
        get :index, params: { page: 1 }

        expect(assigns(:users).count).to eq(5)
      end

      it 'paginates record on second page' do
        get :index, params: { page: 2 }

        expect(assigns(:users).count).to eq(1)
      end

      it 'checks dynamic page limit pagination on first page' do
        get :index, params: { user: { limit: 2 }, page: 1 }

        expect(assigns(:users).count).to eq(2)
      end

      it 'checks dynamic page limit pagination on second page' do
        get :index, params: { user: { limit: 2 }, page: 2 }

        expect(assigns(:users).count).to eq(2)
      end
    end

    context 'Signed in as User' do
      before { sign_in_as user_1 }

      context 'Pagination is not available as unauthorized for view' do
        before { get :index }

        it { is_expected.to_not render_template(:index) }
      end
    end

    context 'Not signed in - Guest User' do
      before { get :index }

      it { is_expected.to set_flash.to('Please sign in to continue.') }
    end
  end

  describe 'Sorting' do
    context 'Signed in as Admin' do
      before { sign_in_as admin_1 }
      before { get :index, params: { q: { s: 'name desc' } } }

      it 'returns sorted user names' do
        expect(assigns(:users)).to eq([admin_1, user_1])
      end
    end

    context 'Signed in as User' do
      before { sign_in_as user_1 }
      before { get :index }

      it 'does not return sorted user names' do
        expect(assigns(:users)).to_not eq([admin_1, user_1])
      end
    end

    context 'Not signed in - Guest User' do
      before { get :index }

      it { is_expected.to_not render_template(:index) }
      it { is_expected.to set_flash.to('Please sign in to continue.') }
    end
  end
end
