require 'rails_helper'

RSpec.describe API::V1::Entities::Author do
  let(:author) { FactoryBot.create(:author) }
  let(:author_entity) { API::V1::Entities::Author.represent(author) }
  let(:expected_hash) { JSON.parse(author_entity.to_json) }
  let(:result) do
    {
      'id' => author.id,
      'full_name' => author.full_name,
      'nick_name' => author.nick_name,
      'biography' => author.biography,
    }
  end

  it 'matches with the expected hash' do
    expect(expected_hash).to eq(result)
  end
end
