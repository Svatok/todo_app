# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :item

  mount_uploader :attachment, AttachmentUploader

  validates_presence_of :comment_text

  default_scope { order(created_at: :asc) }
end
