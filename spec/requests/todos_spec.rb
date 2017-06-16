# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let(:user) { create(:user) }
  let!(:todos) { create_list(:todo, 4, user_id: user.id) }
  let(:todo_id) { todos.first.id }
  let(:headers) { user.create_new_auth_token }

  describe 'GET /api/todos' do
    before { get '/api/todos', params: {}, headers: headers }

    it 'returns todos', :show_in_doc do
      expect(json).not_to be_empty
      expect(json.size).to eq(todos.count)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/todos/:id' do
    before { get "/api/todos/#{todo_id}", params: {}, headers: headers }

    context 'when the record exists', :show_in_doc do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  describe 'POST /api/todos' do
    let(:valid_attributes) { { todo: { title: 'Learn Elm', user_id: user.id.to_s } } }
    let(:invalid_attributes) { { todo: { title: '' } } }

    context 'when the request is valid' do
      before { post '/api/todos', params: valid_attributes, headers: headers }

      it 'creates a todo', :show_in_doc do
        expect(json['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/todos', params: invalid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  describe 'PUT /api/todos/:id' do
    let(:valid_attributes) { { todo: { title: 'Shopping' } } }

    context 'when the record exists' do
      before { put "/api/todos/#{todo_id}", params: valid_attributes, headers: headers }

      it 'updates the record', :show_in_doc do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /api/todos/:id' do
    before { delete "/api/todos/#{todo_id}", params: {}, headers: headers }

    it 'returns status code 204', :show_in_doc do
      expect(response).to have_http_status(204)
    end
  end
end
