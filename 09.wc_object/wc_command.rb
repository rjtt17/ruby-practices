# frozen_string_literal: true

require 'pathname'

module WcCount
  def count_line
    text.count("\n")
  end

  def count_word
    text.split(' ').count
  end

  def count_byte
    text.size
  end
end

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
