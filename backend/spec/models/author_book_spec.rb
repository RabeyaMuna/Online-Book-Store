require 'rails_helper'

RSpec.describe AuthorBook do
  describe 'Validating Factory' do 
    let(:author_book) { FactoryBot.build(:author_book) }

    it 'is a valid author_book' do 
      expect(author_book).to be_valid
    end 
  end 

  describe 'associations' do 
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:author) }
  end 
end
