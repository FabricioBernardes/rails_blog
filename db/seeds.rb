begin
  require 'faker'
rescue LoadError
  puts "Faker gem is not installed. Add it to your Gemfile and run 'bundle install'."
  exit
end

User.create!(
  email: 'admin@admin.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'admin'
)

author_1 = User.create!(
  email: 'author1@author1.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'author'
)

author_2 = User.create!(
  email: 'author2@author2.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'author'
)

post_content = "
  <h2>#{Faker::Lorem.sentence}</h2>
  <p>#{Faker::Lorem.paragraph(sentence_count: 5)}</p>
  <h3>#{Faker::Lorem.sentence}</h3>
  <ul>
    <li>#{Faker::Lorem.sentence}</li>
    <li>#{Faker::Lorem.sentence}</li>
    <li>#{Faker::Lorem.sentence}</li>
    </ul>
  <p>#{Faker::Lorem.paragraph(sentence_count: 10)}</p>
  <p>#{Faker::Lorem.paragraph(sentence_count: 5)}</p>
  <p>#{Faker::Lorem.paragraph(sentence_count: 8)}</p>
"

[ author_1, author_2 ].each do |author|
  10.times do |i|
    title = Faker::Book.title
    Post.create!(
      title: title,
      body: post_content,
      user: author,
      slug: "#{title.parameterize}-#{SecureRandom.hex(4)}"
    )
  end
end

puts "Seeding completed successfully!"
