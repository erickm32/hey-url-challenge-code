# frozen_string_literal: true

module ApplicationHelper
  def base26
    alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    loop do
      random_number = (SecureRandom.rand * 10_000_000).to_i
      hashed_str = ''

      while random_number.positive?
        hashed_str = alphabet[random_number % alphabet.length] + hashed_str
        random_number /= alphabet.length
      end

      return hashed_str if hashed_str.length == 5
    end
  end
end
