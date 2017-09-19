# frozen_string_literal: true

require 'rails_helper'
include Capybara::DSL

RSpec.feature 'Todos' do
  let(:user1) { create :user }
  let!(:user1_todos) { create_list :todo, 10, title: 'todo_user1', user_id: user1.id }
  # let!(:item) { create_list :item, 5, todo_id: 1 }
  let(:user2) { create :user }
  let!(:user2_todos) { create_list :todo, 7, title: 'todo_user2', user_id: user2.id }

  before do
    visit '/'
    @sign_in_page = SignInPage.new
    @sign_in_page.complete_form(user1.email, user1.password)
    wait_for_ajax
  end

  context 'Show todos' do
    scenario 'show 10 user`s todos' do
      expect(page).to have_selector('.project-field', count: user1_todos.count)
    end

    scenario 'not show second user`s todos' do
      user2_todos.each do |todo|
        expect(page).not_to have_content(todo.title)
      end
    end
  end

  context 'Add todo' do
    before do
      @todo_form = TodoForm.new
      find('span', text: 'Add TODO List').click
    end

    scenario 'to page' do
      @todo_form.complete_form('New todo')
      wait_for_ajax
      expect(page).to have_selector('.project-field', count: user1_todos.count + 1)
    end

    scenario 'to db' do
      @todo_form.complete_form('New todo')
      wait_for_ajax
      added_todo = user1.todos.find_by(title: 'New todo')
      expect(added_todo).not_to be_nil
    end

    scenario 'invalid input' do
      @todo_form.complete_form('')
      expect(page).to have_content('Project title must be present!')
    end
  end

  context 'Edit todo' do
    before do
      @todo_form = TodoForm.new
      first('.project-header').hover
      find('.edit').click
    end

    scenario 'in page' do
      @todo_form.complete_form('Updated todo')
      wait_for_ajax
      expect(page).to have_content('Updated todo')
    end

    scenario 'in db' do
      @todo_form.complete_form('Updated todo')
      wait_for_ajax
      updated_todo = user1.todos.find_by(title: 'Updated todo')
      expect(updated_todo).not_to be_nil
    end

    scenario 'invalid input' do
      @todo_form.complete_form('')
      expect(page).to have_content('Project title must be present!')
    end
  end

  context 'Delete todo' do
    before do
      first('.project-header').hover
      find('.delete').click
      wait_for_ajax
    end

    scenario 'in page' do
      expect(page).to have_selector('.project-field', count: user1_todos.count - 1)
    end

    scenario 'in db' do
      user_todos_count = user1.todos.count
      expect(user_todos_count).to eq(user1_todos.count - 1)
    end
  end
end
