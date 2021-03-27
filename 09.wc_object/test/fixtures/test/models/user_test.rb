# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @alice = users(:alice)
    @bob = users(:bob)
  end

  test '#name_or_email' do
    assert_equal 'alice@example.com', @alice.name_or_email
    assert_equal 'bob', @bob.name_or_email
  end

  test '#follow　following?' do
    assert_not @alice.following?(@bob)
    @alice.follow(@bob)
    assert @alice.following?(@bob)
  end

  test '#unfollow　followed_by?' do
    assert_not @bob.followed_by?(@alice)
    @alice.follow(@bob)
    assert @bob.followed_by?(@alice)
    @alice.unfollow(@bob)
    assert_not @bob.followed_by?(@alice)
  end
end
