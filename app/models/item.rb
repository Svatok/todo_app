# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :todo

  has_many :comments, dependent: :destroy

  validates_presence_of :name

  default_scope { order(position: :asc) }
end
