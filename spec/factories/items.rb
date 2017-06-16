# frozen_string_literal: true

FactoryGirl.define do
  factory :item do
    name { FFaker::Lorem.sentence }
    done false
    todo_id nil
  end
end
