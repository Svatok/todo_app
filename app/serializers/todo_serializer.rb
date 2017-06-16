# frozen_string_literal: true

class TodoSerializer < ActiveModel::Serializer
  attributes :id, :title, :user_id, :position, :created_at, :updated_at
end
