# frozen_string_literal: true

class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :customers, through: :invoices

  def self.most_revenue(quantity)
    select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .joins(invoices: [:invoice_items, :transactions])
      .where('result = ?', 'success')
      .group(:id)
      .order('revenue DESC')
      .limit(quantity)
  end

  def self.most_items(quantity)
    select('merchants.*, sum(invoice_items.quantity) AS quantity')
      .joins(invoices: [:invoice_items, :transactions])
      .where('result = ?', 'success')
      .group(:id)
      .order('quantity DESC')
      .limit(quantity)
  end

  def self.revenue_between(start_date, end_date)
    joins(invoices: [:invoice_items, :transactions])
      .where('result = ?', 'success')
      .where('status = ?', 'shipped')
      .where('invoices.created_at >= ?', "#{start_date} 00:00:00")
      .where('invoices.created_at <= ?', "#{end_date} 23:59:59")
      .pluck(Arel.sql('sum(invoice_items.quantity * invoice_items.unit_price) AS revenue'))
      .first
  end

  def self.revenue(merchant_id)
    joins(invoices: [:invoice_items, :transactions])
      .where('result = ?', 'success')
      .where(id: merchant_id)
      .group(:id)
      .pluck(Arel.sql('sum(invoice_items.quantity * invoice_items.unit_price) AS revenue'))
      .first
  end
end
