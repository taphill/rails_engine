# frozen_string_literal: true

module Api
  module V1
    class ItemMerchantsController < ApplicationController
      def index
        merchant = Item.find(params[:item_id]).merchant

        render json: MerchantSerializer.new(merchant)
      end
    end
  end
end
