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
end
