# frozen_string_literal: true

FactoryBot.define do
  factory :url do
    sequence(:short_url) { |i| "ABCD#{i}" }
    sequence(:original_url) { |i| "https://domain#{i}.com/path" }
  end
end
