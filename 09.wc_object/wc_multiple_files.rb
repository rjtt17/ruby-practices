# frozen_string_literal: true

require_relative './wc_count'

class WcMultipleFiles
  attr_reader :filenames

  def initialize(filenames)
    @filenames = filenames.map { |filename| WcFile.new(filename) }
  end

  def format
    filenames.map(&:format).push([total]).join("\n")
  end

  def format_line
    filenames.map(&:format_line).push([total_line]).join("\n")
  end

  private

  def total
    "#{filenames.map(&:count_line).sum.to_s.rjust(8)}#{filenames.map(&:count_word).sum.to_s.rjust(8)}#{filenames.map(&:count_byte).sum.to_s.rjust(8)} total"
  end

  def total_line
    "#{filenames.map(&:count_line).sum.to_s.rjust(8)} total"
  end
end
