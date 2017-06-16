# frozen_string_literal: true

class Todo < ApplicationRecord
  has_many :items, dependent: :destroy

  validates_presence_of :title, :user_id

  default_scope { order(position: :asc) }
end
