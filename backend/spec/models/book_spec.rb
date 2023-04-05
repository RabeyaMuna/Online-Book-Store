require 'rails_helper'

RSpec.describe Book do

  describe 'scopes' do
    describe '.search_book' do
      let!(:book_1) { FactoryBot.create(:book, name: 'SampleFirst') }
      let!(:book_2) { FactoryBot.create(:book, name: 'MiddleSampleIncluded') }
  
      it 'searches books whose name includes search query string and books whose id is from bookid list ' do
        book_list_id=[book_1.id, book_2.id]
        expect(Book.search_book('Sample', book_list_id)).to match_array([book_1, book_2])
      end
    end
  end

  describe 'Validation a book' do
    let(:book) { FactoryBot.create(:book) }
    it 'has a valid factory' do
      expect(book).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:book_genres).dependent(:destroy) }
    it { is_expected.to have_many(:genres).through(:book_genres) }
    it { is_expected.to have_many(:author_books).dependent(:destroy) }
    it { is_expected.to have_many(:authors).through(:author_books) }
    it { is_expected.to have_many(:book_reviews).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:book_reviews) }
    it { is_expected.to have_many(:order_items).dependent(:destroy) }
    it { is_expected.to have_many(:orders).through(:order_items) }
    it { is_expected.to have_many(:images).dependent(:destroy) }
    it { is_expected.to have_one(:avatar_attachment) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:total_copies) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_content_type_of(:avatar).allowing('image/jpg', 'image/jpeg', 'image/png') }
  end
end
