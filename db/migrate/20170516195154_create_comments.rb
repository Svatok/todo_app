# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :comment_text
      t.references :item, foreign_key: true
      t.string :attachment

      t.timestamps
    end
  end
end
