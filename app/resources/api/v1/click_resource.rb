# frozen_string_literal: true

module Api
  module V1
    class ClickResource < JSONAPI::Resource
      attributes :created_at, :browser, :platform

      has_one :url, exclude_links: :default
      exclude_links :default
    end
  end
end
