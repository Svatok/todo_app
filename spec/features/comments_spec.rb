# frozen_string_literal: true

require 'rails_helper'
include Capybara::DSL
include CarrierWaveDirect::Test::CapybaraHelpers

RSpec.feature 'Items' do
  let(:user) { create :user }
  let!(:todo) { create :todo, user_id: user.id }
  let!(:item) { create :item, todo_id: todo.id }
  let!(:comments) { create_list :comment, 5, item_id: item.id }

  before do
    visit '/'
    @sign_in_page = SignInPage.new
    @sign_in_page.complete_form(user.email, user.password)
    wait_for_ajax
    first('.task-item').hover
    find('.comment').click
    wait_for_ajax
  end

  scenario 'Show 5 comments for item' do
    expect(page).to have_selector('.comment-text', count: comments.count)
  end

  context 'Add comment' do
    before { @comment_form = CommentForm.new }

    scenario 'to page' do
      @comment_form.complete_form('New comment')
      wait_for_ajax
      expect(page).to have_content('New comment')
    end

    scenario 'to db' do
      @comment_form.complete_form('New comment')
      wait_for_ajax
      added_comment = item.comments.find_by(comment_text: 'New comment')
      expect(added_comment).not_to be_nil
    end

    scenario 'invalid input' do
      @comment_form.complete_form('')
      expect(page).to have_content('Please enter comment')
    end
  end

  context 'Delete comment' do
    before do
      first('.remove-comment').click
      wait_for_ajax
    end

    scenario 'in page' do
      expect(page).to have_selector('.comment-text', count: comments.count - 1)
    end

    scenario 'in db' do
      comments_count = item.comments.count
      expect(comments_count).to eq(comments.count - 1)
    end
  end
end
