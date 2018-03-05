require 'random_data'
require 'faker'

15.times do
  user = User.new(
    email: Faker::Internet.unique.email,
    password: 'helloworld',
    password_confirmation: 'helloworld'
  )
  user.skip_confirmation!
  user.save!
end

users = User.all

50.times do
  Wiki.create!(
    title: Faker::Book.unique.title,
    body: Faker::Lorem.paragraph(20, true, 0),
    user: users.sample
  )
end

user = User.new(
  email: 'drivas1993@gmail.com',
  password: 'helloworld',
  password_confirmation: 'helloworld',
  role: 'admin'
)
user.skip_confirmation!
user.save!

Faker::Internet.unique.clear
Faker::Book.unique.clear

puts "Seed finished!"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
