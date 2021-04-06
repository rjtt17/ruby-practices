# frozen_string_literal: true

require 'optparse'
require_relative './wc_command'

opt = OptionParser.new
hash_args = { filenames: [], line: false }
opt.on('-l') { |v| hash_args[:line] = v }
opt.parse!(ARGV)
hash_args[:filenames] = ARGV
text = []
if File.pipe?(STDIN)
  while (str = $stdin.gets)
    text << str
  end
  text = text.join
end
puts WcCommand.display(text: text, **hash_args)
