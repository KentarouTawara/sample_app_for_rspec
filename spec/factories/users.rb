FactoryBot.define do
  factory :user do
    email {'test1@example.com'}
    password {'password'}
    password_confirmation {'password'}
  end
end