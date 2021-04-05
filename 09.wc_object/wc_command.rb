# frozen_string_literal: true

require 'pathname'
require_relative './wc_stdin'
require_relative './wc_file'
require_relative './wc_multiple_files'

class WcCommand
  attr_reader :text, :filenames, :line
  def self.display(text: '', filenames: [], line: false)
    wc_command = new(text: text, filenames: filenames, line: line)
    wc_command.display
  end

  def initialize(text: '', filenames: [], line: false)
    @text = text
    @filenames = filenames
    @line = line
  end

  def display
    if !filenames.empty?
      list_argument
    else
      list_stdin
    end
  end

  private

  def list_argument
    if filenames.size >= 2
      line ? WcMultipleFiles.new(filenames).format_line : WcMultipleFiles.new(filenames).format
    else
      line ? WcFile.new(filenames.join).format_line : WcFile.new(filenames.join).format
    end
  end

  def list_stdin
    if text.empty?
      '引数もしくは、標準入力して下さい。'
    else
      line ? WcStdin.new(text).format_line : WcStdin.new(text).format
    end
  end
end
