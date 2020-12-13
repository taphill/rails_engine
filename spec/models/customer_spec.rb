# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end

  describe 'relationships' do
    it { is_expected.to have_many(:invoices) }
    it { is_expected.to have_many(:merchants).through(:invoices) }
  end
end
