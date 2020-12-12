# frozen_string_literal: true

class Invoice < ApplicationRecord
  validates :status, presence: true

  belongs_to :customer
  belongs_to :merchant
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
end
