# frozen_string_literal: true

class SignUpPage
  def complete_form(email, password, password_confirmation = true)
    fill_in 'email', with: email
    fill_in 'password', with: password
    fill_in 'password_confirmation', with: password if password_confirmation
    click_on 'Register'
  end
end
