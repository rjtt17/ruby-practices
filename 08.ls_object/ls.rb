# frozen_string_literal: true

require 'optparse'
require './ls_command'

opt = OptionParser.new
hash_args = { long_format: false, reverse: false, dot: false }
opt.on('-l') { |v| hash_args[:long_format] = v }
opt.on('-r') { |v| hash_args[:reverse] = v }
opt.on('-a') { |v| hash_args[:dot] = v }
opt.parse!(ARGV)
pathname = ARGV.empty? ? Pathname.getwd : Pathname(ARGV[0])
puts LsCommand.display(pathname, **hash_args)
