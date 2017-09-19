# frozen_string_literal: true

class CommentForm
  def complete_form(comment, _attachment = false)
    find(:css, 'textarea').set(comment)
    find('button', text: 'Add Comment').click
  end
end
