# 100.times do |n|
#   name = Faker::Name.name
#   email = "example-#{n+1}@railstutorial.org"
#   User.create!(name: name,
#                email: email,
#                password: 'password',
#                password_confirmation: 'password')
# end

# User.create!(name: 'ding',
#              email: 'ding2@gmail.com',
#              password: 'password',
#              password_confirmation: 'password',
#              admin: true)

users = User.order(:created_at).take(6)
50.times do |n|
  users.each do |user|
   user.microposts.create!(content: Faker::Lorem.sentence(5))
  end
  users.shuffle!
end