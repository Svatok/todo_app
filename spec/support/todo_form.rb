# frozen_string_literal: true

class TodoForm
  def complete_form(title)
    find(:css, '.editable-input').set(title)
    find(:css, '.save').click
  end
end
