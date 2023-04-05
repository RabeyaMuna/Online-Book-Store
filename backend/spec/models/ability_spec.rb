require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  let(:book) { FactoryBot.create(:book) }
  let(:author) { FactoryBot.create(:author) }
  let(:other_user) { FactoryBot.create(:user, role: :user) }

  describe 'when user is an admin' do
    let(:user) { FactoryBot.create(:user, role: :admin) }

    it { is_expected.to be_able_to(:manage, book) }
    it { is_expected.to be_able_to(:manage, author) }
    it { is_expected.to be_able_to(:manage, other_user) }
    it { is_expected.to be_able_to(:update, user) }

    it { is_expected.to_not be_able_to(:update, other_user) }
  end

  describe 'when user is a customer' do
    let(:user) { FactoryBot.create(:user, role: :user) }

    it { is_expected.to be_able_to(:update, user) }
    it { is_expected.to_not be_able_to(:manage, other_user) }

    it { is_expected.to_not be_able_to(:read, User.roles) }
    it { expect(ability.can?(:read, user, :role)).to be(false) }
    it { expect(ability.can?(:write, user, :role)).to be(false) }

    it { is_expected.to_not be_able_to(:manage, book) }
    it { is_expected.to_not be_able_to(:create, book) }
    it { is_expected.to_not be_able_to(:update, book) }
    it { is_expected.to_not be_able_to(:destroy, book) }

    it { is_expected.to_not be_able_to(:manage, author) }
    it { is_expected.to_not be_able_to(:create, author) }
    it { is_expected.to_not be_able_to(:update, author) }
    it { is_expected.to_not be_able_to(:destroy, author) }
  end

  describe 'when there is no user - guest user' do
    let(:user) { nil }

    it { is_expected.to be_able_to(:read, book) }
    it { is_expected.to be_able_to(:read, author) }

    it { is_expected.to_not be_able_to(:manage, book) }
    it { is_expected.to_not be_able_to(:create, book) }
    it { is_expected.to_not be_able_to(:update, book) }
    it { is_expected.to_not be_able_to(:destroy, book) }

    it { is_expected.to_not be_able_to(:manage, author) }
    it { is_expected.to_not be_able_to(:create, author) }
    it { is_expected.to_not be_able_to(:update, author) }
    it { is_expected.to_not be_able_to(:destroy, author) }

    it { is_expected.to_not be_able_to(:manage, user) }
    it { is_expected.to_not be_able_to(:create, user) }
    it { is_expected.to_not be_able_to(:update, user) }
    it { is_expected.to_not be_able_to(:destroy, user) }
  end
end
