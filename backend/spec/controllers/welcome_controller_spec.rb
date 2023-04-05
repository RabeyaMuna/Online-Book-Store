require 'rails_helper'

RSpec.describe WelcomeController do
  let!(:book_1) { FactoryBot.create(:book, copies_sold: 30, publication_year: '21-10-2021') }
  let!(:book_2) { FactoryBot.create(:book, copies_sold: 3000, publication_year: '23-6-1999') }
  let!(:book_3) { FactoryBot.create(:book, copies_sold: 300, publication_year: '1-12-2017') }

  describe 'GET #index' do
    before { get :index, params: { book: { limit: 15 } } }

    it 'shows the list of latest publications' do
      expect(assigns(:recently_published)).to eq([book_1, book_3, book_2])
    end

    it 'shows the books with maximum sale' do
      expect(assigns(:best_sellers)).to eq([book_2, book_3, book_1])
    end

    it 'shows the list of newly added books' do
      expect(assigns(:latest_collection)).to eq([book_3, book_2, book_1])
    end
  end
end
