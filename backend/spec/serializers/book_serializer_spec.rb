require 'rails_helper'

RSpec.describe BookSerializer do
  let(:book) { FactoryBot.create(:book) }
  let(:user) { create(:user, role: :admin) }
  let!(:book_review) { FactoryBot.create(:book_review, user_id: user.id, book_id: book.id) }
  let(:author) { FactoryBot.create(:author) }
  let!(:author_book) { FactoryBot.create(:author_book, book_id: book.id, author_id: author.id) }
  let(:order) { FactoryBot.create(:order, user_id: user.id) }
  let!(:order_item) { FactoryBot.create(:order_item, book_id: book.id, order_id: order.id) }

  let(:result) { BookSerializer.new(book).serializable_hash }

  let(:expected_hash) do
    {
      data:
      {
        id: book.id.to_s,
        type: :book,
        attributes:
        {
          name: book.name,
          price: book.price,
          total_copies: book.total_copies,
          copies_sold: book.copies_sold,
          publication_year: book.publication_year,
        },
        relationships:
        {
          author_books:
          {
            data: [{ id: author_book.id.to_s, type: :author_book }],
          },
          authors:
          {
            data: [{ id: author.id.to_s, type: :author }],
          },
          book_reviews:
          {
            data: [{ id: book_review.id.to_s, type: :book_review }],
          },
          users:
          {
            data: [{ id: user.id.to_s, type: :user }],
          },
          order_items:
          {
            data: [{ id: order_item.id.to_s, type: :order_item }],
          },
          orders:
          {
            data: [{ id: order.id.to_s, type: :order }],
          },
        },
      },
    }
  end

  it 'Serializes json data' do
    expect(result).to eq(expected_hash)
  end
end
