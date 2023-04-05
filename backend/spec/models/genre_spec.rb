require 'rails_helper'

RSpec.describe Genre do
  let!(:genre) { FactoryBot.create(:genre) }

  describe 'scopes' do
    describe '.search_genre' do
      let!(:genre_1) { FactoryBot.create(:genre, name: 'SampleFirst') }
      
      it 'searches all the genres whose name includes the string of search query' do
        expect(Genre.search_genre('Sample')).to match_array([genre_1])
      end
    end
  end

  describe 'Validating Genre Factory' do
    it 'is a valid Genre' do
      expect(genre).to be_valid
    end
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:book_genres).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:book_genres) }
  end
end
