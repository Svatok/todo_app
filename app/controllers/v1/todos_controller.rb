module V1
  class TodosController < ApplicationController
    before_action :authenticate_user!
    before_action :set_todo, only: %i[show update destroy]

    def index
      @todos = current_user.todos
      json_response(@todos)
    end

    def show
      json_response(@todo)
    end

    def create
      create_todo_params = todo_params
      create_todo_params[:position] = current_user.todos.count
      @todo = current_user.todos.create!(create_todo_params)
      json_response(@todo, :created)
    end

    def update
      @todo.update!(todo_params)
      head :no_content
    end

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
