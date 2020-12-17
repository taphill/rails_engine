# frozen_string_literal: true

module Api
  module V1
    class MerchantItemsController < ApplicationController
      def index
        merchant_items = Merchant.find(params[:merchant_id]).items

        render json: ItemSerializer.new(merchant_items)
      end
    end
  end
end
