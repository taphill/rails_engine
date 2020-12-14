# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api/V1/Merchants request', type: :request do
  describe 'valid GET /merchants request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before do
      create_list(:merchant, 3)
      get api_v1_merchants_path
    end

    it { expect(response.status).to eq(200) }

    it { expect(json_body).to be_a(Hash) }
    it { expect(json_body).to have_key(:data) }
    it { expect(json_body[:data]).to be_a(Array) }
    it { expect(json_body[:data].count).to eq(3) }
    it { expect(json_body[:data][0][:attributes]).to be_a(Hash) }

    it 'has item attributes' do
      json_body[:data].each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe 'valid GET /merchants/:id request' do
    let(:merchant) { create(:merchant) }
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before { get api_v1_merchant_path(merchant.id) }

    it { expect(response.status).to eq(200) }

    it { expect(json_body).to be_a(Hash) }
    it { expect(json_body).to have_key(:data) }
    it { expect(json_body[:data]).to be_a(Hash) }
    it { expect(json_body[:data]).to have_key(:attributes) }
    it { expect(json_body[:data][:attributes]).to be_a(Hash) }

    it 'has item attributes' do
      expect(json_body[:data][:attributes]).to have_key(:name)
      expect(json_body[:data][:attributes][:name]).to be_a(String)
    end
  end

  describe 'invalid GET /merchants/:id request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    it 'returns a 404' do
      get api_v1_merchant_path(4)

      expect(response.status).to eq(404)
      expect(json_body).to have_key(:message)
      expect(json_body[:message]).to eq('Not Found')
    end
  end
end
