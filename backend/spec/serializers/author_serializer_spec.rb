require 'rails_helper'

RSpec.describe AuthorSerializer do
  let(:author) { FactoryBot.create(:author) }
  let(:result) { AuthorSerializer.new(author).serializable_hash }
  let(:expected_hash) do
    {
      id: author.id.to_s,
      type: :author,
      attributes:
      {
        full_name: author.full_name,
        nick_name: author.nick_name,
        biography: author.biography,
      },
      relationships:
      {
        books:
        {
          data: [],
        },
        author_books:
          {
            data: [],
          },
      },
    }
  end
  it 'serializes json' do
    expect(result[:data]).to eq(expected_hash)
  end
end
