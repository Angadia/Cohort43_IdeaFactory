# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Idea.destroy_all

ActiveRecord::Base.connection.reset_pk_sequence!(:ideas)

20.times.map do
  i = Idea.create(
    title: Faker::Hacker.say_something_smart,
    description: Faker::GreekPhilosophers.quote,
    created_at: Faker::Date.backward(days: 365),
    updated_at: :created_at
  )

  puts "Failed to persist Idea instance due to #{i.errors.full_messages.join(', ')}" unless i.persisted?
end

puts Cowsay.say("Generated #{Idea.count} ideas using Faker.", :frogs)
