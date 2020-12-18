# frozen_string_literal: true

module Api
  module V1
    class RevenueController < ApplicationController
      def index
        render json: RevenueSerializer.new(
          {
            date: { start: params[:start], end: params[:end] }
          }
        )
      end
    end
  end
end
