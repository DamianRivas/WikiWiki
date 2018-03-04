FactoryBot.define do
  factory :user do
    sequence(:email){ |n| "user#{n}@factory.com" }
    password 'helloworld'
    after(:create) { |u| u.confirm }
  end
end