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

    it 'has merchant attributes' do
      json_body[:data].each do |merchant|
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
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

    it 'has merchant attributes' do
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

  describe 'valid POST /merchants request' do
    let(:merchant_params) { { name: 'Great Item' } }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

    before do
      post api_v1_merchants_path, headers: headers, params: JSON.generate(merchant_params)
    end

    it { expect(response.status).to eq(200) }
    it { expect(Merchant.last.name).to eq(merchant_params[:name]) }
  end

  describe 'no name in POST /merchants request' do
    let(:merchant_params) { { name: '' } }

    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    it 'returns a 403' do
      post api_v1_merchants_path, headers: headers, params: JSON.generate(merchant_params)

      expect(response.status).to eq(403)
      expect(json_body).to have_key(:message)
      expect(json_body[:message]).to eq("Validation failed: Name can't be blank")
    end
  end

  describe 'valid DELETE /merchants/:id request' do
    let!(:merchant) { create(:merchant) }

    it { expect(Merchant.count).to eq(1) }
    it { expect { delete api_v1_merchant_path(merchant.id) }.to change(Merchant, :count).by(-1) }

    it 'deletes the merchant' do
      delete api_v1_merchant_path(merchant.id)
      expect(response.status).to eq(204)
      expect(Item.count).to eq(0)
    end
  end

  describe 'invalid DELETE /merchants/:id request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    it 'returns a 404' do
      delete api_v1_merchant_path(4)
      expect(response.status).to eq(404)
      expect(json_body[:message]).to eq('Not Found')
    end
  end

  describe 'valid PATCH /merchants/:id request' do
    before do
      @id = create(:merchant).id
      @previous_name = Merchant.last.name
      @merchant_params = { name: 'New Best Merchant' }
      @headers = { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'updates a merchant' do
      patch api_v1_merchant_path(@id), headers: @headers, params: JSON.generate(@merchant_params)

      merchant = Merchant.find(@id)
      expect(response.status).to eq(200)
      expect(merchant.name).not_to eq(@previous_name)
      expect(merchant.name).to eq('New Best Merchant')
    end
  end

  describe 'invalid PATCH /merchants/:id request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before do
      @merchant_params = { name: 'New Best Merchant' }
      @headers = { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'returns a 404' do
      patch api_v1_merchant_path(4), headers: @headers, params: JSON.generate(@merchant_params)

      expect(response.status).to eq(404)
      expect(json_body[:message]).to eq('Not Found')
    end
  end

  describe 'no name in PATCH /merchants/:id request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before do
      @id = create(:merchant).id
      @previous_name = Merchant.last.name
      @merchant_params = { name: '' }
      @headers = { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'returns a 403' do
      patch api_v1_merchant_path(@id), headers: @headers, params: JSON.generate(@merchant_params)

      expect(response.status).to eq(403)
      expect(json_body).to have_key(:message)
      expect(json_body[:message]).to eq("Validation failed: Name can't be blank")
    end
  end

  describe 'valid GET /merchants/:id/items request' do
    let(:merchant) { create(:merchant, :with_items, item_count: 3) }
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before { get api_v1_merchant_items_path(merchant.id) }

    it { expect(response.status).to eq(200) }

    it { expect(json_body).to be_a(Hash) }
    it { expect(json_body).to have_key(:data) }
    it { expect(json_body[:data]).to be_a(Array) }
    it { expect(json_body[:data].count).to eq(3) }
    it { expect(json_body[:data][0][:attributes]).to be_a(Hash) }

    it 'has item id' do
      json_body[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        expect(item[:id].to_i).to be_a(Integer)
      end
    end

    it 'has item attributes' do
      json_body[:data].each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
  end

  describe 'invalid GET /merchants/:id/items request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    it 'returns a 404' do
      get api_v1_merchant_items_path(4)

      expect(response.status).to eq(404)
      expect(json_body).to have_key(:message)
      expect(json_body[:message]).to eq('Not Found')
    end
  end

  describe 'valid GET /merchants/find_all?name= request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before do
      create(:merchant, name: 'Tillman Group')
      create(:merchant, name: 'Ike Illard')
      create(:merchant, name: 'Brown, Parker, & Co')
      get '/api/v1/merchants/find_all?name=ILL'
    end

    it { expect(response.status).to eq(200) }

    it 'returns json data' do
      expect(json_body).to be_a(Hash)
      expect(json_body).to have_key(:data)
      expect(json_body[:data]).to be_a(Array)
      expect(json_body[:data].count).to eq(2)
    end

    it 'can find a list of merchants that contain a fragment, case insensitive' do
      expect(json_body[:data][0][:attributes][:name]).to eq('Tillman Group')
      expect(json_body[:data][1][:attributes][:name]).to eq('Ike Illard')
    end
  end

  describe 'valid GET /merchants/find_all?created_at= request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before do
      create(:merchant, name: 'one', created_at: '2012-01-19 14:53:59')
      create(:merchant, name: 'two', created_at: '2012-03-27 14:53:59')
      create(:merchant, name: 'three', created_at: '2012-03-27 14:53:59')
      get '/api/v1/merchants/find_all?created_at=2012-03-27 14:53:59'
    end

    it { expect(response.status).to eq(200) }

    it 'returns json data' do
      expect(json_body).to be_a(Hash)
      expect(json_body).to have_key(:data)
      expect(json_body[:data]).to be_a(Array)
      expect(json_body[:data].count).to eq(2)
    end

    it 'can find a list of merchants that contain a fragment, case insensitive' do
      expect(json_body[:data][0][:attributes][:name]).to eq('two')
      expect(json_body[:data][1][:attributes][:name]).to eq('three')
    end
  end

  describe 'valid GET /merchants/find_all?updated_at= request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before do
      create(:merchant, name: 'one', updated_at: '2012-01-19 14:53:59')
      create(:merchant, name: 'two', updated_at: '2012-03-27 14:53:59')
      create(:merchant, name: 'three', updated_at: '2012-03-27 14:53:59')
      get '/api/v1/merchants/find_all?updated_at=2012-03-27 14:53:59'
    end

    it { expect(response.status).to eq(200) }

    it 'returns json data' do
      expect(json_body).to be_a(Hash)
      expect(json_body).to have_key(:data)
      expect(json_body[:data]).to be_a(Array)
      expect(json_body[:data].count).to eq(2)
    end

    it 'can find a list of merchants that contain a fragment, case insensitive' do
      expect(json_body[:data][0][:attributes][:name]).to eq('two')
      expect(json_body[:data][1][:attributes][:name]).to eq('three')
    end
  end

  #   describe 'valid GET /merchants/find?name= request' do
  #     let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

  #     before do
  #       create(:merchant, name: 'Tillman Group')
  #       create(:merchant, name: 'Ike Illard')
  #       create(:merchant, name: 'Brown, Parker, & Co')
  #       get '/api/v1/merchants/find?name=ILL'
  #     end

  #     it { expect(response.status).to eq(200) }

  #     it 'returns json data' do
  #       expect(json_body[:data]).to be_a(Hash)
  #       expect(json_body[:data][:attributes][:name].downcase).to include('ill')
  #     end
  #   end
end
