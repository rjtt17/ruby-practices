# frozen_string_literal: true

require 'optparse'
require 'pathname'
require 'etc'
require 'date'

class LsCommand
  def self.display(pathname, long_format: false, reverse: false, dot: false)
    pattern = pathname + '*'
    params = dot ? [pattern, File::FNM_DOTMATCH] : [pattern]
    filenames = Dir.glob(*params).sort
    filenames = filenames.reverse if reverse
    long_format ? LongFormatter.new(filenames).list : ShortFormatter.new(filenames).list
  end
end

class LsFormatter
  attr_reader :files_status

  def initialize(filenames)
    @files_status = filenames.map { |filename| FileStatus.new(filename) }
  end

  def max_length_hash(key)
    {
      nlink: files_status.map(&:nlink).map(&:to_s).map(&:size).max,
      username: files_status.map(&:username).map(&:size).max,
      groupname: files_status.map(&:groupname).map(&:size).max,
      size: files_status.map(&:size).map(&:to_s).map(&:size).max,
      basename: files_status.map(&:basename).map(&:size).max
    }[key]
  end

  def fetch_basenames
    files_status.map(&:basename)
  end
end

class LongFormatter < LsFormatter
  def list
    rows = ["total #{total_blocks}"]
    rows += files_status.map(&:to_h).map do |row|
      "#{row[:type]}#{row[:mode]}  #{row[:nlink].to_s.rjust(max_length_hash(:nlink))} #{row[:username].rjust(max_length_hash(:username))}  #{row[:groupname].rjust(max_length_hash(:groupname))}  #{row[:size].to_s.rjust(max_length_hash(:size))} #{row[:mtime]} #{row[:basename]}"
    end
    rows.join("\n")
  end

  private

  def total_blocks
    files_status.map(&:blocks).sum
  end
end

class ShortFormatter < LsFormatter
  def list
    sort_basenames = sort_row(fetch_basenames)
    format(sort_basenames)
  end

  private

  def sort_row(basenames)
    row, remainder = basenames.size.divmod(3)
    if remainder.zero?
      basenames.each_slice(row).map { |arr| arr }.transpose
    else
      basenames = basenames.each_slice(row + 1).map { |arr| arr }
      basenames[0].zip(*basenames[1..-1]).map(&:compact)
    end
  end

  def format(basenames)
    basenames.map do |row_basenames|
      row_basenames.map do |basename|
        basename.ljust(max_length_hash(:basename) + 7)
      end.join.rstrip
    end.join("\n")
  end
end

class FileStatus
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def to_h
    {
      blocks: blocks,
      type: type,
      mode: mode,
      nlink: nlink,
      username: username,
      groupname: groupname,
      size: size,
      mtime: mtime,
      basename: basename
    }
  end

  def stat
    File::Stat.new(filename)
  end

  def blocks
    stat.blocks
  end

  def type
    Pathname(filename).directory? ? 'd' : '-'
  end

  def mode
    digits = sprintf("%#o", stat.mode)[-3..-1]
    digits.each_char.map do |digit|
      fetch_permission(digit)
    end.join
  end

  def nlink
    stat.nlink
  end

  def username
    Etc.getpwuid(stat.uid).name
  end

  def groupname
    Etc.getgrgid(stat.gid).name
  end

  def size
    stat.size
  end

  def mtime
    Time.now.to_date.prev_month(6) > stat.mtime.to_date ? stat.mtime.strftime('%_m %e  %Y') : stat.mtime.strftime('%_m %e %H:%M')
  end

  def basename
    File.basename(filename)
  end

  private

  def fetch_permission(digit)
    {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }[digit]
  end
end

#opt = OptionParser.new
#hash_args = {long_format: false, reverse: false, dot: false}
#opt.on('-l') {|v| hash_args[:long_format] = v }
#opt.on('-r') {|v| hash_args[:reverse] = v }
#opt.on('-a') {|v| hash_args[:dot] = v }
#opt.parse!(ARGV)
#pathname = ARGV.empty? ? Pathname.getwd : Pathname(ARGV[0])
#puts LsCommand.display(pathname, **hash_args)