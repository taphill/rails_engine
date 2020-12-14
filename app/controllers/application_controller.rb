# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def record_not_found
    render json: { message: 'Not Found' }, status: 404
  end

  def record_invalid(error)
    if error.message.include?('must exist')
      render json: { message: error.message }, status: 404
    else
      render json: { message: error.message }, status: 403
    end
  end
end
