# frozen_string_literal: true

module Api
  module V1
    module Merchants
      module BusinessIntelligence
        class RevenueController < ApplicationController
          def index
            merchants = Merchant.most_revenue(params[:quantity])

            render json: MerchantSerializer.new(merchants)
          end

          def show
            merchant = Merchant.find(params[:merchant_id])

            render json: MerchantRevenueSerializer.new(merchant)
          end
        end
      end
    end
  end
end
