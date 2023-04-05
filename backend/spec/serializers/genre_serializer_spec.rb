require 'rails_helper'

RSpec.describe GenreSerializer do
  let(:genre) { FactoryBot.create(:genre) }
  let(:book) { FactoryBot.create(:book) }
  let!(:book_genre) { FactoryBot.create(:book_genre, book_id: book.id, genre_id: genre.id) }

  let(:subject) { GenreSerializer.new(genre).serializable_hash }

  let(:expected_hash) do
    {
      id: genre.id.to_s,
      type: :genre,
      attributes: { name: genre.name },
      relationships:
      {
        books: { data: [{ id: book.id.to_s, type: :book }] },
        book_genres: { data: [{ id: book_genre.id.to_s, type: :book_genre }] },
      },
    }
  end

  it 'matches the data hash' do
    expect(subject[:data]).to eq(expected_hash)
  end
end
