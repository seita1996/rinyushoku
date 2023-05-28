FactoryBot.define do
  factory :schedule do
    date { Date.today }
    meal { association :meal }
    has_debut_food { false }
  end
end
