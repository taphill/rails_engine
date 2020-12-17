# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:unit_price) }
    it { is_expected.to validate_presence_of(:merchant_id) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:merchant) }
    it { is_expected.to have_many(:invoice_items) }
    it { is_expected.to have_many(:invoices).through(:invoice_items) }
  end

  describe 'class methods' do
    describe '.find_all_by_name()' do
      it 'returns an array of items that contain a fragement, case insensitive' do
        item1 = create(:item, name: 'Big Thing')
        item2 = create(:item, name: 'Smallthing')
        create(:item, name: 'Cool')

        expect(described_class.find_all_by_name('tHI')).to eq([item1, item2])
      end
    end

    describe '.find_all_by_description()' do
      it 'returns an array of items that contain a fragement, case insensitive' do
        item1 = create(:item, description: 'Really nice')
        item2 = create(:item, description: 'Its real good')
        create(:item, description: 'bad')

        expect(described_class.find_all_by_description('rEA')).to eq([item1, item2])
      end
    end

    describe '.find_all_by_created_at()' do
      it 'returns an array of items with the created_at date' do
        create(:item, created_at: '2012-01-19 14:53:59')
        item1 = create(:item, created_at: '2012-03-27 14:53:59')
        item2 = create(:item, created_at: '2012-03-27 14:53:59')

        created_at = '2012-03-27 14:53:59'

        expect(described_class.find_all_by_created_at(created_at)).to eq([item1, item2])
      end
    end

    describe '.find_all_by_updated_at()' do
      it 'returns an array of merchants with the created_at date' do
        create(:item, updated_at: '2012-01-19 14:53:59')
        item1 = create(:item, updated_at: '2012-03-27 14:53:59')
        item2 = create(:item, updated_at: '2012-03-27 14:53:59')

        updated_at = '2012-03-27 14:53:59'

        expect(described_class.find_all_by_updated_at(updated_at)).to eq([item1, item2])
      end
    end
  end
end
