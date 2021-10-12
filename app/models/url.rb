# frozen_string_literal: true

class Url < ApplicationRecord
  # scope :latest, -> {}

  validates :original_url, :short_url, presence: true
  validates :short_url, uniqueness: true
  validate :original_url_has_valid_format

  has_many :clicks, dependent: :destroy

  private

  def original_url_has_valid_format
    errors.add(:original_url, :invalid) unless valid_url?
  end

  def valid_url?
    uri = URI.parse(original_url)
    (uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
end
