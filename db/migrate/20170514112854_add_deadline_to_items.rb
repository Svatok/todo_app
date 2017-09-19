# frozen_string_literal: true

class AddDeadlineToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :deadline, :date
  end
end
