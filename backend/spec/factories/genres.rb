FactoryBot.define do
  factory :genre do
    sequence(:name) { |i| ('aaa'..'zzz').to_a[i] }
  end
end
