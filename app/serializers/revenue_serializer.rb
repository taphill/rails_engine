# frozen_string_literal: true

class RevenueSerializer
  include FastJsonapi::ObjectSerializer
  set_id { nil }

  attribute :revenue do |params|
    Merchant.revenue_between(params[:date][:start], params[:date][:end]).to_s
  end
end
