# frozen_string_literal: true

require_relative './wc_count'

class WcFile
  include WcCount
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def format
    "#{count_line.to_s.rjust(8)}#{count_word.to_s.rjust(8)}#{count_byte.to_s.rjust(8)} #{filename}"
  end

  def format_line
    "#{count_line.to_s.rjust(8)} #{filename}"
  end

  private

  def text
    Pathname(filename).read
  end
end
