# frozen_string_literal: true

class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :customers, through: :invoices

  def self.find_all_by_name(name)
    where('lower(name) LIKE ?', "%#{name.downcase}%")
  end

  def self.find_all_by_created_at(created_at)
    where(created_at: created_at)
  end

  def self.find_all_by_updated_at(updated_at)
    where(updated_at: updated_at)
  end
end
