# frozen_string_literal: true

module V1
  class TodosController < ApplicationController
    before_action :authenticate_user!
    before_action :set_todo, only: %i(show update destroy)

    def_param_group :todo do
      param :todo, Hash, required: true, desc: 'Todo (Project) details' do
        param :title, String, desc: 'Todo (Project) title', required: true
        param :position, :number, desc: 'Todo (Project) position for sorting'
      end
    end

    resource_description do
      short 'API for managing Todos (Projects)'
      formats ['json']
      error 401, 'Unauthorized'
      error 404, 'Not Found'
      error 422, 'Validation Error'
      error 500, 'Internal Server Error'
      description <<-EOS
        === Authentication required
         Authentication token has to be passed as part of the request. It can be passed as HTTP headers.
        ==== The authentication headers consists of the following params:
          access-token: This serves as the user's password for each request.
          -----
          client: This enables the use of multiple simultaneous sessions on different clients.
          -----
          expiry: The date at which the current session will expire.
          -----
          uid: A unique value that is used to identify the user.
      EOS
    end

    api! 'Get Todos (Projects)'
    def index
      @todos = current_user.todos
      json_response(@todos)
    end

    api! 'Get Todo (Project)'
    param :id, :number, required: true
    def show
      json_response(@todo)
    end

    api! 'Create Todo (Project)'
    param_group :todo
    def create
      create_todo_params = todo_params
      create_todo_params[:position] = current_user.todos.count
      @todo = current_user.todos.create!(create_todo_params)
      json_response(@todo, :created)
    end

    api! 'Update Todo (Project)'
    param :id, :number, required: true
    param_group :todo
    def update
      @todo.update!(todo_params)
      head :no_content
    end

    api! 'Delete Todo (Project)'
    param :id, :number, required: true
    def destroy
      @todo.destroy
      head :no_content
    end

    private

    def todo_params
      params.require(:todo).permit(:title, :position)
    end

    def set_todo
      @todo = current_user.todos.find(params[:id])
    end
  end
end
