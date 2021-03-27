# frozen_string_literal: true

class Relationship < ApplicationRecord
  belongs_to :following, class_name: 'User'
  belongs_to :follower, class_name: 'User'

  validates :following_id, uniqueness: { scope: :follower_id }
end
