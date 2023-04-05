require 'rails_helper'

RSpec.describe User do
  let!(:user) { create(:user) }

  it 'has a valid user factory' do
    expect(user).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:book_reviews).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:book_reviews) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
    it { is_expected.to have_many(:images).dependent(:destroy) }
    it { is_expected.to have_one(:avatar_attachment) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_content_type_of(:avatar).allowing('image/jpg', 'image/jpeg', 'image/png') }
  end

  describe 'email validations' do
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value('example@gmail.com').for(:email) }
    it { is_expected.not_to allow_value('examplegmail').for(:email) }
  end

  describe 'password validations' do
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
    it { is_expected.to allow_value('something').for(:password) }
    it { is_expected.not_to allow_value('some').for(:password) }
  end

  describe 'phone number validations' do
    it { is_expected.to validate_length_of(:phone) }
    it { is_expected.to allow_value('+8801975091215').for(:phone) }
    it { is_expected.not_to allow_value('+4401975091215').for(:phone) }
    it { is_expected.to allow_value('01975091215').for(:phone) }
    it { is_expected.not_to allow_value('01975').for(:phone) }
  end
end
