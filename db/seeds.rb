require 'random_data'

15.times do
  user = User.new(
    email: RandomData.random_email,
    password: 'helloworld',
    password_confirmation: 'helloworld'
  )
  user.skip_confirmation!
  user.save!
end

users = User.all

50.times do
  Wiki.create!(
    title: RandomData.random_word,
    body: RandomData.random_paragraph,
    user: users.sample
  )
end

user = User.new(
  email: 'drivas1993@gmail.com',
  password: 'helloworld',
  password_confirmation: 'helloworld'
)
user.skip_confirmation!
user.save!

puts "Seed finished!"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
