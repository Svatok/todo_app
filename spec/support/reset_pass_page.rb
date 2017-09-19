# frozen_string_literal: true

class ResetPassPage
  def complete_form(email)
    fill_in 'email', with: email
    click_on 'Reset password'
  end
end
