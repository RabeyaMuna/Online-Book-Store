require 'rails_helper'

RSpec.describe BooksController do
  let!(:book1) { FactoryBot.create(:book, name: 'Six of Crows') }
  let!(:book2) { FactoryBot.create(:book, name: 'Alice in Wonderland') }

  before { sign_in }

  describe 'GET #index' do
    context 'with valid attibutes' do
      before { get :index }

      it { is_expected.to render_template(:index) }
      it { is_expected.to respond_with(:success) }

      it 'assigns all books into Book' do
        expect(assigns(:books)).to match_array([book1, book2])
      end
    end
  end

  describe 'GET #show' do
    context 'with valid attributes' do
      before { get :show, params: { id: book1.id } }

      it { is_expected.to render_template(:show) }
      it { is_expected.to respond_with(:success) }

      it 'assigns the book to @book' do
        expect(assigns(:book)).to eq book1
      end
    end

    context 'with invalid attributes' do
      before { get :show, params: { id: 0 } }

      it { is_expected.to set_flash.to(I18n.t('notice.not_found', resource: Book.model_name.human)) }
    end
  end

  describe 'GET #new' do
    before { get :new }

    it { is_expected.to render_template(:new) }
    it { is_expected.to respond_with(:success) }

    it 'assigns a new book to @book' do
      expect(assigns(:book)).to be_a_new(Book)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:book_params) { FactoryBot.attributes_for(:book) }
      let(:create_action) { post :create, params: { book: book_params } }

      it 'redirects to index' do
        expect(create_action).to redirect_to(books_path)
      end

      it 'flashes success message' do
        create_action

        expect(flash[:success]).to eq(I18n.t('notice.create.success', resource: Book.model_name.human))
      end

      it 'creates a new book into database' do
        expect { create_action }.to change(Book, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      let(:book_params) { FactoryBot.attributes_for(:book, name: '') }
      let(:create_action) { post :create, params: { book: book_params } }

      it 'flashes error message' do
        create_action

        expect(flash[:error]).to eq(I18n.t('notice.create.fail', resource: Book.model_name.human))
      end

      it 'renders new template' do
        expect(create_action).to render_template(:new)
      end

      it 'does not create a book to the database' do
        expect { create_action }.to_not change(Book, :count)
      end
    end
  end

  describe 'GET #edit' do
    context 'with valid attibutes' do
      before { get :edit, params: { id: book1.id } }

      it { is_expected.to render_template(:edit) }
      it { is_expected.to respond_with(:success) }

      it 'assigns book to @book' do
        expect(assigns(:book)).to eq book1
      end
    end

    context 'with  invalid attributes' do
      before { get :edit, params: { id: 0 } }

      it { is_expected.to set_flash.to(I18n.t('notice.not_found', resource: Book.model_name.human)) }
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      let(:new_params) { FactoryBot.attributes_for(:book, name: 'Some Book') }

      before { patch :update, params: { id: book1.id, book: new_params } }

      it { is_expected.to redirect_to(books_path) }

      it 'updates the name of the book' do
        book1.reload

        expect(book1.name).to eq('Some Book')
      end

      it 'flashes success message' do
        book1.reload

        expect(flash[:notice]).to eq(I18n.t('notice.update.success', resource: Book.model_name.human))
      end
    end

    context 'with invalid attributes' do
      let(:new_params) { FactoryBot.attributes_for(:book, name: '') }

      before { patch :update, params: { id: book1.id, book: new_params } }

      it { is_expected.to render_template(:edit) }

      it 'flashes error message' do
        expect(flash[:error]).to eq(I18n.t('notice.update.fail', resource: Book.model_name.human))
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid attributes' do
      let(:delete_action) { delete :destroy, params: { id: book1.id } }

      it 'deletes a book from the database' do
        expect { delete_action }.to change(Book, :count).by(-1)
      end

      it 'flashes succes message' do
        delete_action

        expect(flash[:success]).to eq(I18n.t('notice.delete.success', resource: Book.model_name.human))
      end

      it 'redirects to index' do
        expect(delete_action).to redirect_to(books_path)
      end
    end

    context 'with invalid attributes' do
      let(:delete_action) { delete :destroy, params: { id: 0 } }

      it 'flashed error messages' do
        delete_action

        expect(flash[:error]).to eq(I18n.t('notice.not_found', resource: Book.model_name.human))
      end

      it 'does not delete a book from the database' do
        expect { delete_action }.not_to change(Book, :count)
      end
    end
  end

  describe 'Pagination' do
    before do
      4.times { FactoryBot.create(:book) }
    end

    it 'paginates record on first page with no page param specified' do
      get :index

      expect(assigns(:books).count).to eq(5)
    end

    it 'paginates record on first page' do
      get :index, params: { page: 1 }

      expect(assigns(:books).count).to eq(5)
    end

    it 'paginates record on second page' do
      get :index, params: { page: 2 }

      expect(assigns(:books).count).to eq(1)
    end

    it 'checks dynamic page limit pagination on first page' do
      get :index, params: { book: { limit: 2 } , page: 1 }

      expect(assigns(:books).count).to eq(2)
    end

    it 'checks dynamic page limit pagination on second page' do
      get :index, params: { book: { limit: 2 } , page: 2 }

      expect(assigns(:books).count).to eq(2)
    end
  end

  describe 'Sorting' do
    before { get :index, params: { q: { s: 'name desc' } } }

    it 'returns sorted book names' do
      expect(assigns(:books)).to eq([book1, book2])
    end
  end
end
