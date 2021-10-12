# frozen_string_literal: true

FactoryBot.define do
  factory :click do
    browser { 'chrome' }
    platform { 'linux' }
  end
end
