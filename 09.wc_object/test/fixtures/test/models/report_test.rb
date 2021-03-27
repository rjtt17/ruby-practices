# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#created_on' do
    me = User.create!(email: 'me@example.com', password: 'passward')
    report = me.reports.create!(title: '日報1', content: 'テストは楽しい', created_at: '2020-01-01'.in_time_zone)
    assert_equal Date.new(2020, 1, 1), report.created_on
  end

  test '#editable?' do
    me = User.create!(email: 'me@example.com', password: 'passward')
    she = User.create!(email: 'she@example.com', password: 'passward')
    report = me.reports.create!(title: '日報1', content: 'テストは楽しい')
    assert report.editable?(me)
    assert_not report.editable?(she)
  end
end
