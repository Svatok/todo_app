# frozen_string_literal: true

class AddPositionToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :position, :integer, default: 0
  end
end
