# frozen_string_literal: true

class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :done, :todo_id, :created_at, :updated_at, :position, :deadline
  has_many :comments
end
