# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_all_by_name(name)
    where('lower(name) LIKE ?', "%#{name.downcase}%")
  end

  def self.find_all_by_description(description)
    where('lower(description) LIKE ?', "%#{description.downcase}%")
  end

  def self.find_all_by_created_at(created_at)
    where(created_at: created_at)
  end

  def self.find_all_by_updated_at(updated_at)
    where(updated_at: updated_at)
  end

  def self.find_by_name(name)
    where('lower(name) LIKE ?', "%#{name.downcase}%").limit(1).first
  end

  def self.find_by_created_at(created_at)
    where(created_at: created_at).limit(1).first
  end

  def self.find_by_updated_at(updated_at)
    where(updated_at: updated_at).limit(1).first
  end
end
