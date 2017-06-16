# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:item) }
  it { should validate_presence_of(:comment_text) }
end
