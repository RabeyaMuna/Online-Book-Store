FactoryBot.define do
  factory :author do
    full_name { Faker::Name.name }
    nick_name { Faker::Name.last_name }
    biography { Faker::Hipster.paragraph }
  end
end
