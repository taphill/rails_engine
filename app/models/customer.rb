# frozen_string_literal: true

class Customer < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :invoices, dependent: :destroy
  has_many :merchants, through: :invoices
end
