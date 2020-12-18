# frozen_string_literal: true

module Api
  module V1
    module Merchants
      module BusinessIntelligence
        class ItemsController < ApplicationController
          def index
            merchants = Merchant.most_items(params[:quantity])

            render json: MerchantSerializer.new(merchants)
          end
        end
      end
    end
  end
end
