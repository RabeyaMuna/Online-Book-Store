FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password }
    phone { Faker::Base.unique.numerify('01#########') }
    role { :admin }
  end
end
