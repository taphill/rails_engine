# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }

    trait :with_items do
      transient do
        item_count { 3 }
      end

      after(:create) do |merchant, evaluator|
        merchant.items << create_list(:item, evaluator.item_count)
      end
    end
  end
end
