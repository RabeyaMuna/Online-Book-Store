require 'rails_helper'
RSpec.describe BookReview do
  describe 'Validating Factory' do
    let(:book_review) { FactoryBot.build(:book_review) }

    it 'is a valid Review' do
      expect(book_review).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:review) }
    it { is_expected.to validate_presence_of(:rating) }
    it { is_expected.to define_enum_for(:rating) }
  end
end
