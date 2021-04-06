# frozen_string_literal: true

require_relative './wc_count'

class WcStdin
  include WcCount
  attr_reader :text

  def initialize(text)
    @text = text
  end

  def format
    "#{count_line.to_s.rjust(8)}#{count_word.to_s.rjust(8)}#{count_byte.to_s.rjust(8)}"
  end

  def format_line
    count_line.to_s.rjust(8).to_s
  end
end
