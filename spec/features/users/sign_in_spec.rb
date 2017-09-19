# frozen_string_literal: true

require 'rails_helper'
include Capybara::DSL

RSpec.feature 'Sign Un' do
  let(:user) { create :user }

  before do
    visit '/auth/sign_in'
    @sign_in_page = SignInPage.new
  end

  context 'Authentication' do
    scenario 'with valid inputs' do
      @sign_in_page.complete_form(user.email, user.password)
      expect(page).to have_content('Sign out')
    end

    scenario 'with invalid credentials' do
      @sign_in_page.complete_form(user.email, 'non_actual_pass')
      expect(page).to have_content('Invalid login credentials. Please try again.')
    end

    scenario 'without password' do
      @sign_in_page.complete_form(user.email, '')
      expect(page).to have_content('Please enter password')
    end

    scenario 'without email' do
      @sign_in_page.complete_form('', user.password)
      expect(page).to have_content('Please enter email')
    end

    scenario 'redirect after login' do
      @sign_in_page.complete_form(user.email, user.password)
      wait_for_ajax
      expect(page).to have_content('Add TODO List')
    end
  end

  context 'Page access' do
    scenario 'visiting main page when not signed in' do
      visit '/'
      expect(page).not_to have_content('Add TODO List')
    end

    context 'when signed in' do
      before do
        @sign_in_page.complete_form(user.email, user.password)
        wait_for_ajax
      end

      scenario 'visiting main page ' do
        visit '/'
        expect(page).to have_content('Add TODO List')
      end

      scenario 'visiting signin page' do
        visit '/auth/sign_in'
        expect(page).to have_content('Add TODO List')
      end

      scenario 'visiting signup page' do
        visit '/auth/sign_up'
        expect(page).to have_content('Add TODO List')
      end

      scenario 'visiting reset pass page' do
        visit '/auth/reset_pass'
        expect(page).to have_content('Add TODO List')
      end
    end
  end
end
