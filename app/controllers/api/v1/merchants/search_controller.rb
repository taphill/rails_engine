# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def index
          merchants = Merchant.find_all_by_name(params[:name])

          render json: MerchantSerializer.new(merchants)
        end
      end
    end
  end
end
