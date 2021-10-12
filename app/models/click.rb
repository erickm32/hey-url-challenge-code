# frozen_string_literal: true

class Click < ApplicationRecord
  belongs_to :url

  validates :platform, :browser, presence: true
end
