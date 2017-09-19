# frozen_string_literal: true

module V1
  class ItemsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_todo
    before_action :set_todo_item, only: %i(show update destroy)

    def_param_group :path_params do
      param :id, :number, required: true
      param :todo_id, :number, required: true
    end

    def_param_group :item do
      param :item, Hash, required: true, desc: 'Item (Task) details' do
        param :name, String, desc: 'Item (Task) name', required: true
        param :done, :bool, desc: 'Item (Task) marking of completion'
        param :position, :number, desc: 'Item (Task) position for sorting'
        param :deadline, Date, desc: 'Item (Task) deadline'
      end
    end

    resource_description do
      short 'API for managing Items (Tasks)'
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

    api! 'Get Items (Tasks)'
    param :todo_id, :number, required: true
    def index
      json_response(@todo.items)
    end

    api! 'Get Item (Task)'
    param_group :path_params
    def show
      json_response(@item)
    end

    api! 'Create Item (Task)'
    param_group :item
    def create
      move_items_by_one_position
      new_item = @todo.items.create!(item_params)
      json_response(new_item, :created)
    end

    api! 'Update Item (Task)'
    param_group :path_params
    param_group :item
    def update
      @item.update!(item_params)
      head :no_content
    end

    api! 'Delete Item (Task)'
    param_group :path_params
    def destroy
      @item.destroy
      head :no_content
    end

    private

    def item_params
      params.require(:item).permit(:name, :done, :position, :deadline)
    end

    def set_todo
      @todo = current_user.todos.find(params[:todo_id])
    end

    def set_todo_item
      @item = @todo.items.find_by!(id: params[:id]) if @todo
    end

    def move_items_by_one_position
      @todo.items.each do |item|
        new_position = item.position + 1
        item.update_attributes(position: new_position)
      end
    end
  end
end
