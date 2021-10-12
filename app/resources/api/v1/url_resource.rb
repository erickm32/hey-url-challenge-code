# frozen_string_literal: true

module Api
  module V1
    class UrlResource < JSONAPI::Resource
      paginator :custom
      attributes :created_at, :original_url, :url, :clicks

      def url
        @model.short_url
      end

      def clicks
        @model.clicks_count
      end

      has_many :clicks, exclude_links: :default
      exclude_links :default
    end
  end
end

class CustomPaginator < JSONAPI::Paginator
  def initialize(params)
    super
    @page = params.to_i
  end

  def apply(relation, _order_options)
    relation.order(created_at: :desc).limit(10)
  end
end
