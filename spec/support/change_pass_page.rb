# frozen_string_literal: true

class ChangePassPage
  def complete_form(password, password_confirmation = true)
    fill_in 'password', with: password
    fill_in 'password_confirmation', with: password if password_confirmation
    click_on 'Change password'
  end
end
