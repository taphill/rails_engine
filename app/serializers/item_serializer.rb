# frozen_string_literal: true

class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :unit_price, :merchant_id

  belongs_to :merchant
end
