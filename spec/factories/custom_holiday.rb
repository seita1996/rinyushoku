FactoryBot.define do
  factory :custom_holiday do
    date { Faker::Date.unique.between(from: 30.days.ago, to: Date.today) }
    description { Faker::Coffee.blend_name }
  end
end