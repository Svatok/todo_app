# frozen_string_literal: true

require 'rails_helper'
include Capybara::DSL

RSpec.feature 'SignUp' do
  let(:user) { create :user }
  let(:email) { FFaker::Internet.email }
  let(:password) { FFaker::Internet.password(8) }

  before do
    visit '/auth/sign_up'
    @sign_up_page = SignUpPage.new
  end

  context 'with valid inputs' do
    before { @sign_up_page.complete_form(email, password) }

    scenario 'account creation' do
      find('a', text: 'Sign out').click
      sign_in_page = SignInPage.new
      sign_in_page.visit('/')
      sign_in_page.complete_form(email, password)
      expect(page).to have_content('Sign out')
    end

    scenario 'sign-in upon account creation' do
      expect(page).to have_content('Sign out')
    end
  end

  context 'with invalid inputs' do
    scenario 'email already exists' do
      @sign_up_page.complete_form(user.email, password)
      expect(page).to have_content('Email has already been taken')
    end

    scenario 'without email' do
      @sign_up_page.complete_form('', password)
      expect(page).to have_content('Please enter email')
    end

    scenario 'with not valid email' do
      @sign_up_page.complete_form('aaa', password)
      expect(page).to have_content('Must be a valid email')
    end

    scenario 'without password' do
      @sign_up_page.complete_form(email, '')
      expect(page).to have_content('Please enter password')
    end

    scenario 'with a too-short password' do
      @sign_up_page.complete_form(email, 'a')
      expect(page).to have_content('Password must be at least 8 characters')
    end

    scenario 'without password confirmation' do
      @sign_up_page.complete_form(email, password, false)
      expect(page).to have_content('Please enter password confirmation')
    end
  end
end
