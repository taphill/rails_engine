# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api/V1/Items request', type: :request do
  describe 'GET /items request' do
    before do
      create_list(:item, 3)
      get api_v1_items_path
    end

    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

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

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
  end

  describe 'valid GET /items/:id request' do
    let(:item) { create(:item) }
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before { get api_v1_item_path(item.id) }

    it { expect(response.status).to eq(200) }

    it { expect(json_body).to be_a(Hash) }
    it { expect(json_body).to have_key(:data) }
    it { expect(json_body[:data]).to be_a(Hash) }
    it { expect(json_body[:data]).to have_key(:attributes) }
    it { expect(json_body[:data][:attributes]).to be_a(Hash) }

    it 'has item attributes' do
      expect(json_body[:data][:attributes]).to have_key(:name)
      expect(json_body[:data][:attributes][:name]).to be_a(String)

      expect(json_body[:data][:attributes]).to have_key(:description)
      expect(json_body[:data][:attributes][:description]).to be_a(String)

      expect(json_body[:data][:attributes]).to have_key(:unit_price)
      expect(json_body[:data][:attributes][:unit_price]).to be_a(Float)

      expect(json_body[:data][:attributes]).to have_key(:merchant_id)
      expect(json_body[:data][:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  describe 'invalid GET /items/:id request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    it 'returns a 404' do
      get api_v1_item_path(4)

      expect(response.status).to eq(404)
      expect(json_body).to have_key(:message)
      expect(json_body[:message]).to eq('Not Found')
    end
  end

  describe 'valid POST /items request' do
    let(:merchant) { create(:merchant) }
    let :item_params do
      {
        name: 'Great Item',
        description: 'Likely the best item ever.',
        unit_price: 1200.99,
        merchant_id: merchant.id
      }
    end

    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

    before { post api_v1_items_path, headers: headers, params: JSON.generate(item_params) }

    it { expect(response.status).to eq(200) }

    it { expect(Item.last.name).to eq(item_params[:name]) }
    it { expect(Item.last.description).to eq(item_params[:description]) }
    it { expect(Item.last.unit_price).to eq(item_params[:unit_price]) }
    it { expect(Item.last.merchant_id).to eq(item_params[:merchant_id]) }
  end

  describe 'no name in POST /items request' do
    let(:merchant) { create(:merchant) }
    let :item_params do
      {
        description: 'Likely the best item ever.',
        unit_price: 1200.99,
        merchant_id: merchant.id
      }
    end

    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    it 'returns a 403' do
      post api_v1_items_path, headers: headers, params: JSON.generate(item_params)

      expect(response.status).to eq(403)
      expect(json_body).to have_key(:message)
      expect(json_body[:message]).to eq("Validation failed: Name can't be blank")
    end
  end

  describe 'no description in POST /items request' do
    let(:merchant) { create(:merchant) }
    let :item_params do
      {
        name: 'Great Item',
        unit_price: 1200.99,
        merchant_id: merchant.id
      }
    end

    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    it 'returns a 403' do
      post api_v1_items_path, headers: headers, params: JSON.generate(item_params)

      expect(response.status).to eq(403)
      expect(json_body).to have_key(:message)
      expect(json_body[:message]).to eq("Validation failed: Description can't be blank")
    end
  end

  describe 'no unit_price in POST /items request' do
    let(:merchant) { create(:merchant) }
    let :item_params do
      {
        name: 'Great Item',
        description: 'Likely the best item ever.',
        merchant_id: merchant.id
      }
    end

    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    it 'returns a 403' do
      post api_v1_items_path, headers: headers, params: JSON.generate(item_params)

      expect(response.status).to eq(403)
      expect(json_body).to have_key(:message)
      expect(json_body[:message]).to eq("Validation failed: Unit price can't be blank")
    end
  end

  describe 'non-existant merchant in POST /items request' do
    let :item_params do
      {
        name: 'Great Item',
        description: 'Likely the best item ever.',
        unit_price: 1200.99,
        merchant_id: 8
      }
    end

    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    it 'returns a 404' do
      post api_v1_items_path, headers: headers, params: JSON.generate(item_params)

      expect(response.status).to eq(404)
      expect(json_body).to have_key(:message)
      expect(json_body[:message]).to eq('Validation failed: Merchant must exist')
    end
  end

  describe 'valid DELETE /items/:id request' do
    let!(:item) { create(:item) }

    it { expect(Item.count).to eq(1) }
    it { expect { delete api_v1_item_path(item.id) }.to change(Item, :count).by(-1) }

    it 'deletes the item' do
      delete api_v1_item_path(item.id)
      expect(response.status).to eq(204)
      expect(Item.count).to eq(0)
    end
  end

  describe 'invalid DELETE /items/:id request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    it 'returns a 404' do
      delete api_v1_item_path(4)
      expect(response.status).to eq(404)
      expect(json_body[:message]).to eq('Not Found')
    end
  end

  describe 'valid PATCH /items/:id request' do
    before do
      @id = create(:item).id
      @previous_name = Item.last.name
      @item_params = { name: 'New Best Item' }
      @headers = { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'updates an item' do
      patch api_v1_item_path(@id), headers: @headers, params: JSON.generate(@item_params)

      item = Item.find(@id)
      expect(response.status).to eq(200)
      expect(item.name).not_to eq(@previous_name)
      expect(item.name).to eq('New Best Item')
    end
  end

  describe 'invalid PATCH /items/:id request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    it 'returns a 404' do
      patch api_v1_item_path(4)
      expect(response.status).to eq(404)
      expect(json_body[:message]).to eq('Not Found')
    end
  end

  describe 'no name in PATCH /items/:id request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before do
      @id = create(:item).id
      @previous_name = Item.last.name
      @item_params = { name: '' }
      @headers = { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'returns a 403' do
      patch api_v1_item_path(@id), headers: @headers, params: JSON.generate(@item_params)

      expect(response.status).to eq(403)
      expect(json_body).to have_key(:message)
      expect(json_body[:message]).to eq("Validation failed: Name can't be blank")
    end
  end

  describe 'no description in PATCH /items/:id request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before do
      @id = create(:item).id
      @previous_name = Item.last.name
      @item_params = { description: '' }
      @headers = { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'returns a 403' do
      patch api_v1_item_path(@id), headers: @headers, params: JSON.generate(@item_params)

      expect(response.status).to eq(403)
      expect(json_body).to have_key(:message)
      expect(json_body[:message]).to eq("Validation failed: Description can't be blank")
    end
  end

  describe 'no unit_price in PATCH /items/:id request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before do
      @id = create(:item).id
      @previous_name = Item.last.name
      @item_params = { unit_price: '' }
      @headers = { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'returns a 403' do
      patch api_v1_item_path(@id), headers: @headers, params: JSON.generate(@item_params)

      expect(response.status).to eq(403)
      expect(json_body).to have_key(:message)
      expect(json_body[:message]).to eq("Validation failed: Unit price can't be blank")
    end
  end

  describe 'non-existant merchant in PATCH /items/:id request' do
    let(:json_body) { JSON.parse(response.body, symbolize_names: true) }

    before do
      @id = create(:item).id
      @previous_name = Item.last.name
      @item_params = { merchant_id: 800 }
      @headers = { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'returns a 404' do
      patch api_v1_item_path(@id), headers: @headers, params: JSON.generate(@item_params)

      expect(response.status).to eq(404)
      expect(json_body).to have_key(:message)
      expect(json_body[:message]).to eq('Validation failed: Merchant must exist')
    end
  end
end
