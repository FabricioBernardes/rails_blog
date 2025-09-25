# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# Ensure Faker is installed
begin
  require 'faker'
rescue LoadError
  puts "Faker gem is not installed. Add it to your Gemfile and run 'bundle install'."
  exit
end

# Create a user
User.create!(
  email: 'test@test.com',
  password: 'password123',
  password_confirmation: 'password123'
)

# Create 10 posts
10.times do
  Post.create!(
    title: Faker::Book.title,
    body: Faker::Lorem.paragraph(sentence_count: 5),
    user_id: User.first.id
  )
end

puts "Seeding completed successfully!"
