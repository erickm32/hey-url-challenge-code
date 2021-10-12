# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'

# WebDrivers Gem
# https://github.com/titusfortner/webdrivers
#
# Official Guides about System Testing
# https://api.rubyonrails.org/v5.2/classes/ActionDispatch/SystemTestCase.html

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Short Urls', type: :system do
  before do
    driven_by :selenium, using: :chrome
    # If using Firefox
    # driven_by :selenium, using: :firefox
    #
    # If running on a virtual machine or similar that does not have a UI, use
    # a headless driver
    # driven_by :selenium, using: :headless_chrome
    # driven_by :selenium, using: :headless_firefox
  end

  describe 'index' do
    before { create_list(:url, 10) }

    it 'shows a list of short urls' do
      visit root_path
      expect(page).to have_text('HeyURL!')
      expect(find('tbody').all('tr').count).to eq(10)
    end
  end

  describe 'show' do
    let(:url) { create(:url) }
    before do
      url.clicks << Click.create(url: url, platform: 'linux', browser: 'chrome')
      url.clicks << Click.create(url: url, platform: 'macOS', browser: 'chrome')
      url.clicks << Click.create(url: url, platform: 'windows', browser: 'edge')
    end
    it 'shows a panel of stats for a given short url' do
      visit url_path(url.short_url)
      expect(page).to have_text(url.short_url)
      expect(page).to have_text(url.created_at.strftime('%b %d, %Y'))
      expect(page).to have_text(url.original_url)
      # not quite tested, for say, but requires some data to be present, at least
      expect(page).to have_text('total clicks')
      expect(page).to have_text(Click.last.created_at.strftime('%b %d, %Y'))
      expect(page).to have_text('Browsers')
      expect(page).to have_text('chrome')
      expect(page).to have_text('edge')
      expect(page).to have_text('Platform')
      expect(page).to have_text('linux')
      expect(page).to have_text('macOS')
      expect(page).to have_text('windows')
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit url_path('NOTFOUND')
        # expect page to be a 404
        # is this enough?
        expect(page.body).to have_text('The page you were looking for doesn\'t exist (404)')
      end
    end
  end

  describe 'create' do
    context 'when url is valid' do
      before do
        visit root_path
        fill_in 'url[original_url]', with: 'http://google.com'
      end

      it 'creates the short url' do
        expect do
          click_button 'Shorten URL'
        end.to change(Url, :count).by(1)
        expect(Url.last.original_url).to eq('http://google.com')
      end

      it 'redirects to the home page' do
        click_button 'Shorten URL'
        expect(page).to have_current_path(urls_path)
      end
    end

    context 'when url is invalid' do
      before do
        visit root_path
        fill_in 'url[original_url]', with: 'invalid_url'
      end

      it 'does not create the short url and shows a message' do
        expect do
          click_button 'Shorten URL'
        end.to change(Url, :count).by(0)
        expect(Url.count).to eq(0)
        expect(page).to have_text('Original url is invalid')
      end

      it 'redirects to the home page' do
        click_button 'Shorten URL'
        expect(page).to have_current_path(urls_path)
        # add more expections
      end
    end
  end

  # Wasn't able to actually verify the redirection with this system spec
  # made a request spec instead
  describe 'visit' do
    let(:url) { create(:url) }

    xit 'redirects the user to the original url' do
      visit visit_path(url.short_url)
      expect(page.current_url).to eq(url.original_url)
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit visit_path('NOTFOUND')
        # expect page to be a 404
        expect(page.body).to have_text('The page you were looking for doesn\'t exist (404)')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
