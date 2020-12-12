# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to belong_to(:merchant) }
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_many(:invoice_items) }
    it { is_expected.to have_many(:items).through(:invoice_items) }
  end
end
