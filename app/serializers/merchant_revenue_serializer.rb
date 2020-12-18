# frozen_string_literal: true

class MerchantRevenueSerializer
  include FastJsonapi::ObjectSerializer
  set_id { nil }

  attribute :revenue do |object|
    Merchant.revenue(object.id).to_s
  end
end
