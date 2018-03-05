FactoryBot.define do
  factory :user do
    sequence(:email){ |n| "user#{n}@factory.com" }
    password 'helloworld'
    role 'standard'
    after(:create) { |u| u.confirm }
  end
end