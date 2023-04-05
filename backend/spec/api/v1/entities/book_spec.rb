require 'rails_helper'

RSpec.describe API::V1::Entities::Book do
  let(:book) { FactoryBot.create(:book) }
  let(:book_entity) { API::V1::Entities::Book.represent(book) }
  let(:expected_output) { JSON.parse(book_entity.to_json) }

  let(:result) do
    {
      'id' => book.id,
      'name' => book.name,
      'price' => book.price,
      'total_copies' => book.total_copies,
    }
  end

  it 'matches the api specification' do
    expect(expected_output).to eq(result)
  end
end
