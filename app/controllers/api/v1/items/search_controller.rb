# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def index
          render json: ItemSerializer.new(items)
        end

        def show
          render json: ItemSerializer.new(item)
        end

        private

        def items
          return Item.find_all_by_name(params[:name]) if params[:name]
          return Item.find_all_by_description(params[:description]) if params[:description]
          return Item.find_all_by_price(params[:unit_price]) if params[:unit_price]
          return Item.find_all_by_created_at(params[:created_at]) if params[:created_at]
          return Item.find_all_by_updated_at(params[:updated_at]) if params[:updated_at]
        end

        # rubocop:disable Rails/DynamicFindBy
        def item
          return Item.find_by_name(params[:name]) if params[:name]
          return Item.find_by_description(params[:description]) if params[:description]
          return Item.find_by_price(params[:unit_price]) if params[:unit_price]
          return Item.find_by_created_at(params[:created_at]) if params[:created_at]
          return Item.find_by_updated_at(params[:updated_at]) if params[:updated_at]
        end
        # rubocop:enable Rails/DynamicFindBy
      end
    end
  end
end
