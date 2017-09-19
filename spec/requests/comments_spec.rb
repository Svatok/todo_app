# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Items API' do
  let(:user) { create(:user) }
  let!(:todo) { create(:todo, user_id: user.id) }
  let!(:item) { create(:item, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:item_id) { item.id }
  let!(:comments) { create_list(:comment, 4, item_id: item.id) }
  let(:id) { comments.first.id }
  let(:headers) { user.create_new_auth_token }

  describe 'GET /api/todos/:todo_id/items/:item_id/comments' do
    before { get "/api/todos/#{todo_id}/items/#{item_id}/comments", params: {}, headers: headers }

    context 'when item exists' do
      it 'returns status code 200', :show_in_doc do
        expect(response).to have_http_status(200)
      end

      it 'returns all item comments' do
        expect(json.size).to eq(comments.count)
      end
    end

    context 'when item does not exist' do
      let(:item_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'GET /api/todos/:todo_id/items/:item_id/comments/:id' do
    before { get "/api/todos/#{todo_id}/items/#{item_id}/comments/#{id}", params: {}, headers: headers }

    context 'when comment exists', :show_in_doc do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the comment' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when comment does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Comment/)
      end
    end
  end

  describe 'POST /api/todos/:todo_id/items/:todo_id/comments' do
    let(:valid_attributes) { { comment_text: 'New comment' } }

    context 'when request attributes are valid' do
      before { post "/api/todos/#{todo_id}/items/#{item_id}/comments", params: valid_attributes, headers: headers }

      it 'returns status code 201', :show_in_doc do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/api/todos/#{todo_id}/items/#{item_id}/comments", params: { comment_text: '' }, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Comment text can't be blank/)
      end
    end
  end

  describe 'PUT /api/todos/:todo_id/items/:item_id/comments/:id' do
    let(:valid_attributes) { { comment_text: 'Updated' } }

    before { put "/api/todos/#{todo_id}/items/#{item_id}/comments/#{id}", params: valid_attributes, headers: headers }

    context 'when comment exists', :show_in_doc do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the comment' do
        updated_comment = Comment.find(id)
        expect(updated_comment.comment_text).to match(/Updated/)
      end
    end

    context 'when the comment does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Comment/)
      end
    end
  end

  describe 'DELETE /api/todos/:todo_id/items/:item_id/comments/:id' do
    before { delete "/api/todos/#{todo_id}/items/#{item_id}/comments/#{id}", params: {}, headers: headers }

    it 'returns status code 204', :show_in_doc do
      expect(response).to have_http_status(204)
    end
  end
end
