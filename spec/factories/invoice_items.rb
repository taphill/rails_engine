# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_item do
    invoice
    item
    quantity { Faker::Number.within(range: 1..10) }
    unit_price { Faker::Commerce.price }
  end
end
