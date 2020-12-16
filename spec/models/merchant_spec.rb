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
        merchant3 = create(:merchant, name: 'Brown, Parker, & Co')

        expect(Merchant.find_all_by_name('ILL')).to eq([merchant1, merchant2])
      end
    end
  end
end
