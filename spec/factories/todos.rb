# frozen_string_literal: true

FactoryGirl.define do
  factory :todo do
    title { FFaker::Lorem.word }
    user_id { rand(0..10) }
    sequence(:position) { |n| n }
  end
end
