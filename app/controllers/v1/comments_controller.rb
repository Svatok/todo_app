# frozen_string_literal: true

module V1
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_item_with_todo
    before_action :set_comment, only: %i(show update destroy)

    def_param_group :path_params do
      param :id, :number, required: true
      param :item_id, :number, required: true
      param :todo_id, :number, required: true
    end

    def_param_group :comment do
      param :comment_text, String, desc: 'Comment text', required: true
      param :attachment, File, desc: 'Attachment for comment'
    end

    resource_description do
      short 'API for managing Comments of Item (Task)'
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

    api! 'Get Comments'
    param :item_id, :number, required: true
    param :todo_id, :number, required: true
    def index
      json_response(@item.comments)
    end

    api! 'Get Comment'
    param_group :path_params
    def show
      json_response(@comment)
    end

    api! 'Create Comment'
    param_group :comment
    def create
      new_comment = @item.comments.create!(comment_params)
      json_response(new_comment, :created)
    end

    api! 'Update Comment'
    param_group :path_params
    param_group :comment
    def update
      @comment.update!(comment_params)
      head :no_content
    end

    api! 'Delete Comment'
    param_group :path_params
    def destroy
      @comment.destroy
      head :no_content
    end

    private

    def comment_params
      params.permit(:comment_text, :attachment)
    end

    def set_item_with_todo
      @todo = current_user.todos.find(params[:todo_id])
      @item = @todo.items.find_by!(id: params[:item_id]) if @todo
    end

    def set_comment
      @comment = @item.comments.find_by!(id: params[:id]) if @item
    end
  end
end
