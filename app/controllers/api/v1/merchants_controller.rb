# frozen_string_literal: true

module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render json: MerchantSerializer.new(Merchant.all)
      end

      def show
        render json: MerchantSerializer.new(Merchant.find(params[:id]))
      end

      def create
        render json: MerchantSerializer.new(Merchant.create!(merchant_params))
      end

      def update
        merchant = Merchant.find(params[:id])
        raise ActiveRecord::RecordInvalid, merchant unless merchant.update(merchant_params)

        render json: MerchantSerializer.new(Merchant.update(params[:id], merchant_params))
      end

      def destroy
        Merchant.delete(params[:id]) if Merchant.find(params[:id])
      end

      private

      def merchant_params
        params.permit(:name)
      end
    end
  end
end
