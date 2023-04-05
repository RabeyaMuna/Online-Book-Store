require 'rails_helper'

RSpec.describe SearchController do
  let(:book_1) { FactoryBot.create(:book, name: 'Othello', copies_sold: 30, publication_year: '21-10-2021') }
  let(:book_2) { FactoryBot.create(:book, copies_sold: 3000, publication_year: '23-6-1999') }
  let!(:book_3) { FactoryBot.create(:book, copies_sold: 300, publication_year: '1-12-2017') }

  let(:author_1) { FactoryBot.create(:author, full_name: 'Bahello') }
  let(:author_2) { FactoryBot.create(:author, nick_name: 'hello-bello') }

  let!(:author_book_1) { FactoryBot.create(:author_book, author_id: author_1.id, book_id: book_1.id) }
  let!(:author_book_2) { FactoryBot.create(:author_book, author_id: author_2.id, book_id: book_2.id) }

  describe 'GET #search_without_gem' do
    before { get :search_without_gem, params: { search: { search_text: 'Hello' } } }

    it { is_expected.to render_template(:search_without_gem) }

    it 'shows the books with similar book/author/genre name' do
      expect(assigns(:booklist)).to match_array([book_1, book_2])
    end

    it 'does not show irrelevant books' do
      expect(assigns(:booklist)).to_not match_array([book_1, book_2, book_3])
    end
  end

  describe 'GET #search_with_gem' do
    before { get :search_with_gem, params: { q: { name_cont: 'Hello' } } }

    it { is_expected.to render_template(:search_with_gem) }

    it 'shows the books that match the filters' do
      expect(assigns(:books)).to match_array([book_1])
    end

    it 'does not show irrelevant books' do
      expect(assigns(:books)).to_not match_array([book_1, book_2, book_3])
    end
  end
end
