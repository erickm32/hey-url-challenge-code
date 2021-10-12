# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Short Urls Visits', type: :request do
  describe 'visit' do
    let(:url) { create(:url) }

    it 'redirects the user to the original url' do
      get visit_path(url.short_url)
      expect(response).to redirect_to(url.original_url)
    end

    context 'when not found' do
      it 'shows a 404 page' do
        get visit_path('NOTFOUND')
        # expect page to be a 404
        expect(response.status).to eq(404)
        expect(response.body).to include('The page you were looking for doesn\'t exist (404)')
      end
    end
  end
end
