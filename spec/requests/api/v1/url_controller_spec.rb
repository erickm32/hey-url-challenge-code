# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Api::V1::UrlsController, type: :request do
  let!(:headers) { { Accept: 'application/vnd.api+json', 'Content-Type': 'application/vnd.api+json' } }

  describe 'index' do
    describe 'response format' do
      let!(:url) { create(:url) }
      let!(:click) { create(:click, url: url) }

      context 'with ?include params' do
        it 'returns a JSONAPI formatted response including the clicks' do
          get api_v1_urls_path(include: 'clicks'), headers: headers

          expect(response).to be_successful
          expect(JSON.parse(response.body)).to eq(
            {
              data: [
                {
                  id: url.id.to_s,
                  type: 'urls',
                  attributes: {
                    'created-at': url.created_at,
                    'original-url': url.original_url,
                    url: url.short_url,
                    clicks: url.clicks_count
                  },
                  relationships: {
                    clicks: {
                      data: [
                        {
                          type: 'clicks',
                          id: click.id.to_s
                        }
                      ]
                    }
                  }
                }
              ],
              included: [
                {
                  id: click.id.to_s,
                  type: 'clicks',
                  attributes: {
                    'created-at': click.created_at,
                    browser: click.browser,
                    platform: click.platform
                  },
                  relationships: {
                    url: {
                      data: {
                        type: 'urls',
                        id: url.id.to_s
                      }
                    }
                  }
                }
              ]
            }.as_json
          )
        end
      end

      context 'without ?include params' do
        it 'returns a JSONAPI formatted response without including the clicks' do
          get api_v1_urls_path, headers: headers

          expect(response).to be_successful
          expect(JSON.parse(response.body)).to eq(
            {
              data: [
                {
                  id: url.id.to_s,
                  type: 'urls',
                  attributes: {
                    'created-at': url.created_at,
                    'original-url': url.original_url,
                    url: url.short_url,
                    clicks: url.clicks_count
                  }
                }
              ]
            }.as_json
          )
        end
      end
    end

    describe 'response content lenght' do
      context 'with ?include params' do
        before { 15.times { create(:click, url: create(:url)) } }

        it 'returns a JSONAPI formatted response including the clicks' do
          get api_v1_urls_path(include: 'clicks'), headers: headers

          expect(response).to be_successful
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['data'].length).to eq(10)
          expect(parsed_response['included'].length).to eq(10)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
