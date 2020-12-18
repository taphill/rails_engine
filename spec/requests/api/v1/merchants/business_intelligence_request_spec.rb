# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api/V1/Merchants business intelligence request', type: :request do
  describe 'valid GET /api/v1/merchants/most_revenue?quantity=x request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before do
      get '/api/v1/merchants/most_revenue?quantity=2'
    end

    it { expect(response.status).to eq(200) }
  end

  describe 'valid GET /api/v1/merchants/:id/revenue request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before do
      merchant = create(:merchant)
      get "/api/v1/merchants/#{merchant.id}/revenue"
    end

    it { expect(response.status).to eq(200) }
  end
end
