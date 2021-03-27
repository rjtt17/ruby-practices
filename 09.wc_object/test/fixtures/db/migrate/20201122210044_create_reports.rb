# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
