require 'rails_helper'

RSpec.describe GenresController do
  let!(:genre_1) { FactoryBot.create(:genre) }
  let!(:genre_2) { FactoryBot.create(:genre) }

  before { sign_in }

  describe 'GET #index' do
    context 'With valid template' do
      before { get :index }

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:index) }

      it 'assigns all genres into Genres' do
        expect(assigns(:genres)).to match_array([genre_1, genre_2])
      end
    end
  end

  describe 'GET #show' do
    context 'With valid attributes' do
      before { get :show, params: { id: genre_1.id } }

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:show) }
    end

    context 'with invalid attributes' do
      before { get :show, params: { id: 0 } }

      it { is_expected.to set_flash.to(I18n.t('notice.not_found', resource: Genre.model_name.human)) }
    end
  end

  describe 'GET #new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:new) }

    it 'assigns a new genre to a @genre' do
      expect(assigns(:genre)).to be_a_new(Genre)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:genre_params) { FactoryBot.attributes_for(:genre) }
      let(:create_action) { post :create, params: { genre: genre_params } }

      it 'shows saved message' do
        create_action

        expect(flash[:success]).to eq(I18n.t('notice.create.success', resource: Genre.model_name.human))
      end

      it 'saves a genre to database' do
        expect { create_action }.to change(Genre, :count).by(1)
      end

      it 'redirects to genres index page' do
        expect(create_action).to redirect_to(action: :index)
      end
    end

    context 'with invalid attributes' do
      let(:genre_params) { FactoryBot.attributes_for(:genre, name: '') }
      let(:create_action) { post :create, params: { genre: genre_params } }

      it 'shows error message' do
        create_action

        expect(flash[:error]).to eq(I18n.t('notice.create.fail', resource: Genre.model_name.human))
      end

      it 'renders edit template' do
        expect(create_action).to render_template(:new)
      end

      it 'does not create genre into database' do
        expect { create_action }.to_not change(Genre, :count)
      end
    end
  end

  describe 'GET #edit' do
    context 'with valid attibutes' do
      before { get :edit, params: { id: genre_1.id } }

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:edit) }
    end

    context 'with invalid attributes' do
      before { get :edit, params: { id: 0 } }

      it { is_expected.to set_flash.to(I18n.t('notice.not_found', resource: Genre.model_name.human)) }
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      let(:new_params) { FactoryBot.attributes_for(:genre, name: 'New Name') }
      before { patch :update, params: { id: genre_1.id, genre: new_params } }

      it { is_expected.to redirect_to(action: :index) }
      it { is_expected.to set_flash.to(I18n.t('notice.update.success', resource: Genre.model_name.human)) }

      it 'checks for updated name' do
        genre_1.reload

        expect(genre_1.name).to eq('New Name')
      end
    end

    context 'with invalid attributes' do
      let(:new_params) { FactoryBot.attributes_for(:genre, name: '') }
      before { patch :update, params: { id: genre_1.id, genre: new_params } }

      it { is_expected.to render_template(:edit) }
      it { is_expected.to set_flash.to(I18n.t('notice.update.fail', resource: Genre.model_name.human)) }

      it 'shows error message' do
        genre_1.reload

        expect(flash[:error]).to eq(I18n.t('notice.update.fail', resource: Genre.model_name.human))
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid attributes' do
      let(:delete_action) { delete :destroy, params: { id: genre_1.id } }

      it 'deletes a genre from database' do
        expect { delete_action }.to change(Genre, :count).by(-1)
      end

      it 'shows confirmation message' do
        delete_action

        expect(flash[:success]).to eq(I18n.t('notice.delete.success', resource: Genre.model_name.human))
      end
    end

    context 'with invalid attributes' do
      let(:delete_action) { delete :destroy, params: { id: 0 } }

      it 'shows flash error message' do
        delete_action

        expect(flash[:error]).to eq(I18n.t('notice.not_found', resource: Genre.model_name.human))
      end

      it 'does not delete genre from database' do
        expect { delete_action }.to_not change(Genre, :count)
      end
    end
  end
  describe 'Pagination' do
    before { FactoryBot.create(:genre) }

    it 'paginates record on first page with no page param specified' do
      get :index

      expect(assigns(:genres).count).to eq(3)
    end

    it 'paginates record on first page' do
      get :index, params: { page: 1 }

      expect(assigns(:genres).count).to eq(3)
    end

    it 'paginates record on second page' do
      get :index, params: { page: 2 }

      expect(assigns(:genres).count).to eq(0)
    end

    it 'checks dynamic page limit pagination on first page' do
      get :index, params: { genre: { limit: 2 }, page: 1 }

      expect(assigns(:genres).count).to eq(2)
    end

    it 'checks dynamic page limit pagination on second page' do
      get :index, params: { genre: { limit: 2 }, page: 2 }

      expect(assigns(:genres).count).to eq(1)
    end
  end
  describe 'Sorting' do
    before { get :index, params: { q: { s: 'name asc' } } }

    it 'returns sorted genre names' do
      expect(assigns(:genres)).to eq([genre_1, genre_2])
    end
  end
end
