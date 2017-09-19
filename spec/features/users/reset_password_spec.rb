# frozen_string_literal: true

require 'rails_helper'
include Capybara::DSL

RSpec.feature 'Reset password' do
  let(:user) { create :user }
  let(:password) { FFaker::Internet.password(8) }

  before do
    visit '/auth/reset_pass'
    @reset_pass_page = ResetPassPage.new
    @change_pass_page = ChangePassPage.new
    @reset_pass_page.complete_form(user.email)
    wait_for_ajax
    open_email(user.email)
  end

  scenario 'send letter with change password link' do
    expect(current_email).to have_content 'Change my password'
  end

  context 'change password page' do
    before do
      current_email.click_link 'Change my password'
    end

    scenario 'update password' do
      @change_pass_page.complete_form(password)
      wait_for_ajax
      expect(page).to have_content('Your password has been successfully updated!')
    end

    context 'with invalid inputs' do
      scenario 'without password' do
        @change_pass_page.complete_form('')
        expect(page).to have_content('Please enter password')
      end

      scenario 'with a too-short password' do
        @change_pass_page.complete_form('a')
        expect(page).to have_content('Password must be at least 8 characters')
      end

      scenario 'without password confirmation' do
        @change_pass_page.complete_form(password, false)
        expect(page).to have_content('Please enter password confirmation')
      end
    end
  end
end
