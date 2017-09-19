# frozen_string_literal: true

FactoryGirl.define do
  factory :comment do
    comment_text { FFaker::Lorem.paragraph }
    item_id nil
  end
end
