# frozen_string_literal: true

class AddPositionToTodos < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :position, :integer, default: 0
  end
end
