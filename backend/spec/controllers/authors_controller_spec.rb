require 'rails_helper'

RSpec.describe AuthorsController do
  let!(:author_1) { FactoryBot.create(:author, full_name: 'Stephen King') }
  let!(:author_2) { FactoryBot.create(:author, full_name: 'JK Rowling') }

  before { sign_in }

  describe 'GET #index' do
    context 'With valid template' do
      before { get :index }

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:index) }

      it 'assigns all author into Authors' do
        expect(assigns(:authors)).to match_array([author_1, author_2])
      end
    end

    context 'With invalid template' do
      before { get :new }

      it { is_expected.to_not render_template(:index) }
    end
  end

  describe 'GET #show' do
    context 'With valid attributes' do
      before { get :show, params: { id: author_1.id } }

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:show) }
    end

    context 'with invalid attributes' do
      before { get :show, params: { id: 0 } }

      it { is_expected.to set_flash.to(I18n.t('notice.not_found', resource: Author.model_name.human)) }
    end
  end

  describe 'GET #new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:new) }

    it 'assigns a new author to @author' do
      expect(assigns(:author)).to be_a_new(Author)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:author_params) { FactoryBot.attributes_for(:author) }
      let(:create_action) { post :create, params: { author: author_params } }

      it 'shows saved message' do
        create_action

        expect(flash[:success]).to eq(I18n.t('notice.create.success', resource: Author.model_name.human))
      end

      it 'an author added to database' do
        expect { create_action }.to change(Author, :count).by(1)
      end

      it 'redirects to authors index page' do
        expect(create_action).to redirect_to(action: :index)
      end
    end

    context 'with invalid attributes' do
      let(:author_params) { FactoryBot.attributes_for(:author, full_name: '') }
      let(:create_action) { post :create, params: { author: author_params } }

      it 'shows error message' do
        create_action

        expect(flash[:error]).to eq(I18n.t('notice.create.fail', resource: Author.model_name.human))
      end

      it 'renders edit template' do
        expect(create_action).to render_template(:new)
      end

      it 'does not create author into database' do
        expect { create_action }.to_not change(Author, :count)
      end
    end
  end

  describe 'GET #edit' do
    context 'with valid attibutes' do
      before { get :edit, params: { id: author_1.id } }

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:edit) }
    end

    context 'with invalid attributes' do
      before { get :edit, params: { id: 0 } }

      it { is_expected.to set_flash.to(I18n.t('notice.not_found', resource: Author.model_name.human)) }
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      let(:new_params) { FactoryBot.attributes_for(:author, full_name: 'New Name') }
      before { patch :update, params: { id: author_1.id, author: new_params } }

      it { is_expected.to redirect_to(action: :index) }
      it { is_expected.to set_flash.to(I18n.t('notice.update.success', resource: Author.model_name.human)) }

      it 'checks for updated full_name' do
        author_1.reload

        expect(author_1.full_name).to eq('New Name')
      end
    end

    context 'with invalid attributes' do
      let(:new_params) { FactoryBot.attributes_for(:author, full_name: '') }
      before { patch :update, params: { id: author_1.id, author: new_params } }

      it { is_expected.to render_template(:edit) }
      it { is_expected.to set_flash.to(I18n.t('notice.update.fail', resource: Author.model_name.human)) }

      it 'shows error message' do
        author_1.reload

        expect(flash[:error]).to eq(I18n.t('notice.update.fail', resource: Author.model_name.human))
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid attributes' do
      let(:delete_action) { delete :destroy, params: { id: author_1.id } }

      it 'an author deleted from database' do
        expect { delete_action }.to change(Author, :count).by(-1)
      end

      it 'shows confirmation message' do
        delete_action

        expect(flash[:success]).to eq(I18n.t('notice.delete.success', resource: Author.model_name.human))
      end
    end

    context 'with invalid attributes' do
      let(:delete_action) { delete :destroy, params: { id: 0 } }

      it 'shows flash error message' do
        delete_action

        expect(flash[:error]).to eq(I18n.t('notice.not_found', resource: Author.model_name.human))
      end

      it 'does not delete author from database' do
        expect { delete_action }.to_not change(Author, :count)
      end
    end
  end
  describe 'Pagination' do
    before do
      4.times { FactoryBot.create(:author) }
    end

    it 'paginates record on first page with no page param specified' do
      get :index

      expect(assigns(:authors).count).to eq(5)
    end

    it 'paginates record on first page' do
      get :index, params: { page: 1 }

      expect(assigns(:authors).count).to eq(5)
    end

    it 'paginates record on second page' do
      get :index, params: { page: 2 }

      expect(assigns(:authors).count).to eq(1)
    end

    it 'checks dynamic page limit pagination on first page' do
      get :index, params: { author: { limit: 2 } , page: 1 }

      expect(assigns(:authors).count).to eq(2)
    end

    it 'checks dynamic page limit pagination on second page' do
      get :index, params: { author: { limit: 2 } , page: 2 }

      expect(assigns(:authors).count).to eq(2)
    end
  end

  describe 'Sorting' do
    before { get :index, params: { q: { s: 'full_name desc' } } }

    it 'returns sorted author names' do
      expect(assigns(:authors)).to eq([author_1, author_2])
    end
  end
end
