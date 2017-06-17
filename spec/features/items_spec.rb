# frozen_string_literal: true

require 'rails_helper'
include Capybara::DSL

RSpec.feature 'Items' do
  let(:user1) { create :user }
  let!(:user1_todo) { create :todo, user_id: user1.id }
  let!(:user1_items) { create_list :item, 5, todo_id: user1_todo.id }
  let(:user2) { create :user }
  let!(:user2_todo) { create :todo, user_id: user2.id }
  let!(:user2_items) { create_list :item, 7, todo_id: user2_todo.id }

  before do
    visit '/'
    @sign_in_page = SignInPage.new
    @sign_in_page.complete_form(user1.email, user1.password)
    wait_for_ajax
  end

  context 'Show items' do
    scenario 'show 5 user`s items' do
      expect(page).to have_selector('.task-item', count: user1_items.count)
    end

    scenario 'not show second user`s items' do
      user2_items.each do |item|
        expect(page).not_to have_content(item.name)
      end
    end
  end

  context 'Add item' do
    before { @item_form = ItemForm.new }

    scenario 'to page' do
      @item_form.complete_add_item_form('New item')
      wait_for_ajax
      expect(page).to have_content('New item')
    end

    scenario 'to db' do
      @item_form.complete_add_item_form('New item')
      wait_for_ajax
      added_item = user1_todo.items.find_by(name: 'New item')
      expect(added_item).not_to be_nil
    end

    scenario 'invalid input' do
      @item_form.complete_add_item_form('')
      expect(page).to have_content('Task name must be present!')
    end
  end

  context 'Edit item' do
    context 'change item text' do
      before do
        @item_form = ItemForm.new
        first('.task-item').hover
        find('.edit').click
      end

      scenario 'in page' do
        @item_form.complete_update_item_form('Updated item')
        wait_for_ajax
        expect(page).to have_content('Updated item')
      end

      scenario 'in db' do
        @item_form.complete_update_item_form('Updated item')
        wait_for_ajax
        updated_item = user1_todo.items.find_by(name: 'Updated item')
        expect(updated_item).not_to be_nil
      end

      scenario 'invalid input' do
        @item_form.complete_update_item_form('')
        expect(page).to have_content('Task name must be present!')
      end
    end

    context 'mark item' do
      context 'as complete' do
        before do
          first('.task-item').click
          wait_for_ajax
        end

        scenario 'on page' do
          expect(page).to have_selector('.task-done', count: 1)
        end

        scenario 'on db' do
          completed_item = user1_todo.items.find_by(done: true)
          expect(completed_item).not_to be_nil
        end
      end

      context 'as uncomplete' do
        let!(:completed_item) { create :item, done: true, todo_id: user1_todo.id }

        before do
          visit '/'
          wait_for_ajax
          first('.task-done').click
          wait_for_ajax
        end

        scenario 'on page' do
          expect(page).not_to have_selector('.task-done')
        end

        scenario 'on db' do
          completed_item = user1_todo.items.find_by(done: true)
          expect(completed_item).to be_nil
        end
      end
    end

    context 'set deadline' do
      before do
        @current_date = Time.now.strftime('%Y-%m-%d')
        first('.task-item').hover
        find('.comment').click
        find('.glyphicon-calendar').click
        find('button', text: 'Today').click
        wait_for_ajax
      end

      scenario 'on db' do
        item_with_deadline = user1_todo.items.find_by(deadline: @current_date)
        expect(item_with_deadline).not_to be_nil
      end
    end
  end

  context 'Delete item' do
    before do
      first('.task-item').hover
      first('.delete').click
      wait_for_ajax
    end

    scenario 'in page' do
      expect(page).to have_selector('.task-item', count: user1_items.count - 1)
    end

    scenario 'in db' do
      user_items_count = user1_todo.items.count
      expect(user_items_count).to eq(user1_items.count - 1)
    end
  end
end
