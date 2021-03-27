# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:one)
    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報'
    assert_text 'テストについての日報'
    assert_text 'alice@example.com'
  end

  test 'creating a Report' do
    visit reports_url
    click_on '新規作成'
    assert_current_path new_report_path
    fill_in 'タイトル', with: 'テストの日報２'
    fill_in '内容', with: 'テストを書くのは楽しい'
    click_on '登録する'
    assert_text '日報が作成されました。'
    assert_text 'テストの日報２'
    assert_text 'テストを書くのは楽しい'
    assert_current_path report_path(2)
  end

  test 'updating a Report' do
    visit report_path(@report.id)
    click_on '編集'
    fill_in 'タイトル', with: 'テストの日報3'
    fill_in '内容', with: 'テストを書くのが上達したかも'
    click_on '更新する'
    assert_text '日報が更新されました。'
    assert_text 'テストの日報3'
    assert_text 'テストを書くのが上達したかも'
    assert_current_path report_path(@report.id)
  end

  test 'destroying a Report' do
    visit reports_url
    page.accept_confirm do
      click_on '削除'
    end
    assert_text '日報が削除されました。'
  end
end
