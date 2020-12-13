# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    invoice
    sequence(:credit_card_number, 1000) { |i| i }
    credit_card_expiration_date { '08/24' }
    result { 'success' }
  end
end
