require 'rails_helper'

RSpec.describe UserSerializer do
  let(:user) { FactoryBot.create(:user) }
  let!(:order) { FactoryBot.create(:order, user_id: user.id) }
  let(:book) { FactoryBot.create(:book) }
  let!(:book_review) { FactoryBot.create(:book_review, book_id: book.id, user_id: user.id) }

  let(:result) { UserSerializer.new(user).serializable_hash }

  let(:expected_hash) do
    {
      id: user.id.to_s,
      type: :user,
      attributes:
      {
        name: user.name,
        email: user.email,
        password: user.password,
        phone: user.phone,
        role: user.role,
      },
      relationships:
      {
        orders:
        {
          data: [{ id: order.id.to_s, type: :order }],
        },
        book_reviews:
        {
          data: [{ id: book_review.id.to_s, type: :book_review }],
        },
        books:
        {
          data: [{ id: book.id.to_s, type: :book }],
        },
      },
    }
  end

  it 'serializes json' do
    expect(result[:data]).to eq(expected_hash)
  end
end
