# frozen_string_literal: true

class ItemForm
  def complete_add_item_form(name)
    first('.create-task-header input').set(name)
    first('button.add-task').click
  end

  def complete_update_item_form(name)
    first('.editable-input').set(name)
    first('.save').click
  end
end
