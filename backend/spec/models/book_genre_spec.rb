require 'rails_helper'

RSpec.describe BookGenre do
  describe 'Validating Factory' do 
    let(:book_genre) { FactoryBot.build(:book_genre) }

    it 'is a valid book_genre' do 
      expect(book_genre).to be_valid
    end 
  end 

  describe 'associations' do 
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:genre) }
  end 
end
