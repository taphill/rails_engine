# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def index
          render json: MerchantSerializer.new(merchants)
        end

        def show
          render json: MerchantSerializer.new(merchant)
        end

        private

        def merchants
          return Merchant.find_all_by_name(params[:name]) if params[:name]
          return Merchant.find_all_by_created_at(params[:created_at]) if params[:created_at]
          return Merchant.find_all_by_updated_at(params[:updated_at]) if params[:updated_at]
        end

        # rubocop:disable Rails/DynamicFindBy
        def merchant
          return Merchant.find_by_name(params[:name]) if params[:name]
          return Merchant.find_by_created_at(params[:created_at]) if params[:created_at]
          return Merchant.find_by_updated_at(params[:updated_at]) if params[:updated_at]
        end
        # rubocop:enable Rails/DynamicFindBy
      end
    end
  end
end
