# frozen_string_literal: true

require 'rails_helper'
include Capybara::DSL

RSpec.feature 'SignOut' do
  let(:user) { create :user }

  before do
    visit '/auth/sign_in'
    @sign_in_page = SignInPage.new
    @sign_in_page.complete_form(user.email, user.password)
  end

  scenario 'sign out' do
    find('a', text: 'Sign out').click
    expect(page).to have_content('Sign in')
  end
end
