# frozen_string_literal: true

class SignInPage
  def complete_form(email, password)
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    find('button', text: 'Sign in').click
  end
end
