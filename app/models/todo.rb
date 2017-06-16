class Todo < ApplicationRecord

  validates_presence_of :title, :user_id

  default_scope { order(position: :asc) }
end
