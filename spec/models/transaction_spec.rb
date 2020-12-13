# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:credit_card_number) }
    it { is_expected.to validate_presence_of(:credit_card_expiration_date) }
    it { is_expected.to validate_presence_of(:result) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:invoice) }
  end
end
