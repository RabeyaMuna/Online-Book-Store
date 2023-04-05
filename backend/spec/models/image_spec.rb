require 'rails_helper'

RSpec.describe Image do
  let(:for_book) { FactoryBot.create(:image, :for_book) }
  let(:image) { FactoryBot.build(:image) }

  describe 'associations' do
    it { is_expected.to belong_to(:imageable) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:image_path) }

    it 'has a valid book_image factory' do
      expect(for_book).to be_valid
    end
  end
end
