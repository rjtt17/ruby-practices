# frozen_string_literal: true

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
