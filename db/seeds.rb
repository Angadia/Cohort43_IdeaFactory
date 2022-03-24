# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

PASSWORD = '123'

Idea.destroy_all
User.destroy_all

ActiveRecord::Base.connection.reset_pk_sequence!(:ideas)
ActiveRecord::Base.connection.reset_pk_sequence!(:users)

3.times do |n|
  User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: "email#{n}@example.com",
    password: PASSWORD
  )
end

users = User.all

puts Cowsay.say("Created #{users.count} users", :tux)
puts Cowsay.say("Users email are #{(users.map(&:email)).join(', ')}", :kitty)

20.times.map do
  user = users.sample
  i = Idea.create(
    title: Faker::Hacker.say_something_smart,
    description: Faker::GreekPhilosophers.quote,
    created_at: Faker::Date.backward(days: 365),
    updated_at: :created_at,
    user_id: user.id
  )

  puts "Failed to persist Idea instance due to #{i.errors.full_messages.join(', ')}" unless i.persisted?
end

puts Cowsay.say("Generated #{Idea.count} ideas using Faker.", :frogs)
