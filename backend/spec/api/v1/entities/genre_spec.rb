require 'rails_helper'

RSpec.describe API::V1::Entities::Genre do
  let(:genre) { FactoryBot.create(:genre) }
  let(:genre_entity) { API::V1::Entities::Genre.represent(genre) }
  let(:expected_output) { JSON.parse(genre_entity.to_json) }

  let(:result) do
    {
      'id' => genre.id,
      'name' => genre.name,
    }
  end

  it 'matches the api specification' do
    expect(expected_output).to eq(result)
  end
end
