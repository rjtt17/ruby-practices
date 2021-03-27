# frozen_string_literal: true
require 'test/unit'
require_relative '../wc_command.rb'

class WcCommandTest < Test::Unit::TestCase
  FILENAME = ["./fixtures/Gemfile"]
  FILENAMES = ["./fixtures/Gemfile","./fixtures/Gemfile.lock"]

  def test_one_argument
    expected = <<-TEXT.chomp
      70     280    2058 ./fixtures/Gemfile
    TEXT
    assert_equal expected, WcCommand.display(filenames: FILENAME)
  end

  def test_one_argument_with_loption
    expected = <<-TEXT.chomp
      70 ./fixtures/Gemfile
    TEXT
    assert_equal expected, WcCommand.display(filenames: FILENAME, line: true)
  end

  def test_two_argument
    expected = <<-TEXT.chomp
      70     280    2058 ./fixtures/Gemfile
     352     910    8580 ./fixtures/Gemfile.lock
     422    1190   10638 total
    TEXT
    assert_equal expected, WcCommand.display(filenames: FILENAMES)
  end

  def test_two_argument_with_loption
    expected = <<-TEXT.chomp
      70 ./fixtures/Gemfile
     352 ./fixtures/Gemfile.lock
     422 total
    TEXT
    assert_equal expected, WcCommand.display(filenames: FILENAMES, line: true)
  end

  def test_stdin
    text = <<~TEXT
      total 736
      -rw-r--r--    1 hirokitanaka  staff    2058  2 15 14:18 Gemfile
      -rw-r--r--    1 hirokitanaka  staff    8580  2 15 14:18 Gemfile.lock
      -rw-r--r--    1 hirokitanaka  staff    3786  1  1 21:36 README.md
      -rw-r--r--    1 hirokitanaka  staff     258  2 15 14:18 Rakefile
      drwxr-xr-x   12 hirokitanaka  staff     384  2 15 14:18 app
      -rw-r--r--    1 hirokitanaka  staff    1722  1  1 21:36 babel.config.js
      drwxr-xr-x   10 hirokitanaka  staff     320  1  1 21:36 bin
      drwxr-xr-x   17 hirokitanaka  staff     544  2 15 14:18 config
      -rw-r--r--    1 hirokitanaka  staff     191  2 15 14:18 config.ru
      drwxr-xr-x   10 hirokitanaka  staff     320  3  1 22:55 db
      drwxr-xr-x    4 hirokitanaka  staff     128  1  1 21:36 lib
      drwxr-xr-x    5 hirokitanaka  staff     160  2 15 13:50 log
      drwxr-xr-x  773 hirokitanaka  staff   24736  1  1 22:36 node_modules
      -rw-r--r--    1 hirokitanaka  staff     318  1  1 21:36 package.json
      -rw-r--r--    1 hirokitanaka  staff     224  1  1 21:36 postcss.config.js
      drwxr-xr-x   11 hirokitanaka  staff     352  2 22 09:45 public
      drwxr-xr-x    3 hirokitanaka  staff      96  1  1 21:36 storage
      drwxr-xr-x   12 hirokitanaka  staff     384  2 15 14:18 test
      drwxr-xr-x   10 hirokitanaka  staff     320  3  1 22:52 tmp
      drwxr-xr-x    3 hirokitanaka  staff      96  1  1 21:36 vendor
      -rw-r--r--    1 hirokitanaka  staff  332067  1  1 21:36 yarn.lock
    TEXT

    expected = <<-TEXT.chomp
      22     191    1363
    TEXT
    assert_equal expected, WcCommand.display(text: text)
  end

  def test_stdin_with_loption
    text = <<~TEXT
    total 736
    -rw-r--r--    1 hirokitanaka  staff    2058  2 15 14:18 Gemfile
    -rw-r--r--    1 hirokitanaka  staff    8580  2 15 14:18 Gemfile.lock
    -rw-r--r--    1 hirokitanaka  staff    3786  1  1 21:36 README.md
    -rw-r--r--    1 hirokitanaka  staff     258  2 15 14:18 Rakefile
    drwxr-xr-x   12 hirokitanaka  staff     384  2 15 14:18 app
    -rw-r--r--    1 hirokitanaka  staff    1722  1  1 21:36 babel.config.js
    drwxr-xr-x   10 hirokitanaka  staff     320  1  1 21:36 bin
    drwxr-xr-x   17 hirokitanaka  staff     544  2 15 14:18 config
    -rw-r--r--    1 hirokitanaka  staff     191  2 15 14:18 config.ru
    drwxr-xr-x   10 hirokitanaka  staff     320  3  1 22:55 db
    drwxr-xr-x    4 hirokitanaka  staff     128  1  1 21:36 lib
    drwxr-xr-x    5 hirokitanaka  staff     160  2 15 13:50 log
    drwxr-xr-x  773 hirokitanaka  staff   24736  1  1 22:36 node_modules
    -rw-r--r--    1 hirokitanaka  staff     318  1  1 21:36 package.json
    -rw-r--r--    1 hirokitanaka  staff     224  1  1 21:36 postcss.config.js
    drwxr-xr-x   11 hirokitanaka  staff     352  2 22 09:45 public
    drwxr-xr-x    3 hirokitanaka  staff      96  1  1 21:36 storage
    drwxr-xr-x   12 hirokitanaka  staff     384  2 15 14:18 test
    drwxr-xr-x   10 hirokitanaka  staff     320  3  1 22:52 tmp
    drwxr-xr-x    3 hirokitanaka  staff      96  1  1 21:36 vendor
    -rw-r--r--    1 hirokitanaka  staff  332067  1  1 21:36 yarn.lock
    TEXT

    expected = <<-TEXT.chomp
      22
    TEXT
    assert_equal expected, WcCommand.display(text: text, line: true)
  end

  def test_stdin_and_one_argument
    text = <<~TEXT
      total 16
      drwxr-xr-x  23 hirokitanaka  staff   736  3 26 23:43 fixtures
      -rw-r--r--   1 hirokitanaka  staff  6056  3 27 20:54 wc_test.rb
    TEXT

    expected = <<-TEXT.chomp
      70     280    2058 ./fixtures/Gemfile
    TEXT
    assert_equal expected, WcCommand.display(text: text, filenames: FILENAME)
  end
end
