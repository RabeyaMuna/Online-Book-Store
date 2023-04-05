require 'rails_helper'

RSpec.describe API::V1::Entities::User do
  let(:user) { FactoryBot.create(:user) }
  let(:user_entity) { API::V1::Entities::User.represent(user) }
  let(:expected_output) { JSON.parse(user_entity.to_json) }
  let(:result) do
    {
      'id' => user.id,
      'name' => user.name,
      'email' => user.email,
      'password' => user.password,
      'phone' => user.phone,
      'role' => user.role,
    }
  end

  it 'matches the api specification' do
    expect(expected_output).to eq(result)
  end
end
