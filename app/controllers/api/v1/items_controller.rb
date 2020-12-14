# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        render json: ItemSerializer.new(Item.all)
      end

      def show
        render json: ItemSerializer.new(Item.find(params[:id]))
      end

      def create
        render json: ItemSerializer.new(Item.create!(item_params))
      end

      def update
        render json: ItemSerializer.new(Item.update(params[:id], item_params))
      end

      def destroy
        Item.delete(params[:id]) if Item.find(params[:id])
      end

      private

      def item_params
        params.permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
