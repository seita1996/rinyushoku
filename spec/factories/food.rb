FactoryBot.define do
  factory :food do
    name { Faker::Food.unique.vegetables }
  end
end
