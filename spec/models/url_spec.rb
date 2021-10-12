# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:original_url) }
    it { is_expected.to validate_presence_of(:short_url) }

    context 'short_url uniqueness' do
      subject { build(:url, original_url: 'http://google.com', short_url: 'ABCDE') }
      it { is_expected.to validate_uniqueness_of(:short_url) }
    end

    describe 'URL format validation' do
      let(:url) { build(:url, original_url: 'http://google.com') }

      it 'is valid with http protocol(?)' do
        expect(url).to be_valid
      end

      it 'is valid with https protocol(?)' do
        url.original_url = 'https://google.com'
        expect(url).to be_valid
      end

      it 'is invalid with another uri protocol(?)' do
        url.original_url = 'ftp://google.com'
        expect(url).not_to be_valid
      end

      it 'is invalid with a nil host' do
        url.original_url = 'https://'
        expect(url).not_to be_valid
      end

      it 'is invalid with an invalid host' do
        url.original_url = 'http://invalid##host.com'
        expect(url).not_to be_valid
      end
    end
  end
end
