# frozen_string_literal: true

require 'test/unit'
require 'pathname'
require_relative '../ls_command.rb'

class LsCommandTest < Test::Unit::TestCase
  PATHNAME = Pathname('fixtures/books_app')
  NOT_EXIST_PATHNAME = Pathname('not_exitst/path')

  def test_ls
    expected = <<~TEXT.chomp
      Gemfile                 config                  postcss.config.js
      Gemfile.lock            config.ru               public
      README.md               db                      storage
      Rakefile                lib                     test
      app                     log                     tmp
      babel.config.js         node_modules            vendor
      bin                     package.json            yarn.lock
    TEXT
    assert_equal expected, LsCommand.display(PATHNAME)
  end

  def test_ls_l_option
    expected = `ls -l #{PATHNAME}`.chomp
    assert_equal expected, LsCommand.display(PATHNAME, long_format: true)
  end

  def test_ls_r_option
    expected = <<~TEXT.chomp
      yarn.lock               package.json            bin
      vendor                  node_modules            babel.config.js
      tmp                     log                     app
      test                    lib                     Rakefile
      storage                 db                      README.md
      public                  config.ru               Gemfile.lock
      postcss.config.js       config                  Gemfile
    TEXT
    assert_equal expected, LsCommand.display(PATHNAME, reverse: true)
  end

  def test_ls_a_option
    expected = <<~TEXT.chomp
      .                       Rakefile                package.json
      ..                      app                     postcss.config.js
      .browserslistrc         babel.config.js         public
      .git                    bin                     storage
      .gitignore              config                  test
      .rubocop.yml            config.ru               tmp
      .ruby-version           db                      vendor
      Gemfile                 lib                     yarn.lock
      Gemfile.lock            log
      README.md               node_modules
    TEXT
    assert_equal expected, LsCommand.display(PATHNAME, dot: true)
  end

  def test_ls_ar_option
    expected = <<~TEXT.chomp
      yarn.lock               lib                     Gemfile
      vendor                  db                      .ruby-version
      tmp                     config.ru               .rubocop.yml
      test                    config                  .gitignore
      storage                 bin                     .git
      public                  babel.config.js         .browserslistrc
      postcss.config.js       app                     ..
      package.json            Rakefile                .
      node_modules            README.md
      log                     Gemfile.lock
    TEXT
    assert_equal expected, LsCommand.display(PATHNAME, reverse: true, dot: true)
  end

  def test_ls_alr_option
    expected = `ls -alr #{PATHNAME}`.chomp
    assert_equal expected, LsCommand.display(PATHNAME, long_format: true, reverse: true, dot: true)
  end

  def test_not_exist_path
    e = assert_raises ArgumentError do
      LsCommand.display(NOT_EXIST_PATHNAME)
    end
    assert_equal 'パス not_exitst/path は存在しません', e.message
  end
end
