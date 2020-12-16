# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'relationships' do
    it { is_expected.to have_many(:items) }
    it { is_expected.to have_many(:invoices) }
    it { is_expected.to have_many(:customers).through(:invoices) }
  end

  describe 'class methods' do
    describe '.find_all_by_name()' do
      it 'returns an array of merchants that contain a fragement, case insensitive' do
        merchant1 = create(:merchant, name: 'Tillman Group')
        merchant2 = create(:merchant, name: 'Ike Illard')
        create(:merchant, name: 'Brown, Parker, & Co')

        expect(described_class.find_all_by_name('ILL')).to eq([merchant1, merchant2])
      end
    end

    describe '.find_all_by_created_at()' do
      it 'returns an array ofr merchants with the created_at date' do
        create(:merchant, created_at: '2012-01-19 14:53:59')
        merchant1 = create(:merchant, created_at: '2012-03-27 14:53:59')
        merchant2 = create(:merchant, created_at: '2012-03-27 14:53:59')

        created_at = '2012-03-27 14:53:59'

        expect(described_class.find_all_by_created_at(created_at)).to eq([merchant1, merchant2])
      end
    end

    describe '.find_all_by_updated_at()' do
      it 'returns an array ofr merchants with the created_at date' do
        create(:merchant, updated_at: '2012-01-19 14:53:59')
        merchant1 = create(:merchant, updated_at: '2012-03-27 14:53:59')
        merchant2 = create(:merchant, updated_at: '2012-03-27 14:53:59')

        updated_at = '2012-03-27 14:53:59'

        expect(described_class.find_all_by_updated_at(updated_at)).to eq([merchant1, merchant2])
      end
    end
  end
end
