require 'rails_helper'

RSpec.describe Author do
  let(:author) { FactoryBot.build(:author) }
  
  describe 'scopes' do
    describe '.search_author' do
      let!(:author_1) { FactoryBot.create(:author, full_name: 'SampleFirst') }
      let!(:author_2) { FactoryBot.create(:author, full_name: 'MiddleSampleIncluded') }
      
      it 'searches all the authors whose fullname/nickname/biography includes the string of search query' do
        expect(Author.search_author('Sample')).to match_array([author_1, author_2])
      end
    end
  end

  describe 'Validating Author Factory' do
    it 'is a valid Author' do
      expect(author).to be_valid
    end
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to validate_presence_of(:nick_name) }
    it { is_expected.to validate_presence_of(:biography) }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:author_books).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:author_books) }
  end
end
