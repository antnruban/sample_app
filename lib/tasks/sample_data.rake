namespace :db do
  desc "Fill database with sample users data"
  task populate: :environment do
    create_users
    create_microposts
    create_relations
  end
end


def create_users
  User.create!(name: "Admin User", email: "firstadmin@post.dom", password: "password", password_confirmation: "password",
               admin: true)
  99.times do |n|
    name  = Faker::Name.name
    email = "name-#{n+1}@post.dom"
    password  = "password"
    user = User.create!(name: name, email: email, password: password, password_confirmation: password)
  end

  # prompt to shell
  puts "#{"*" * 23}\r\nUsers are created!\r\n"
end

def create_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content ) }
  end

  # prompt to shell
  puts "#{"*" * 23}\r\nMicroposts are created!\r\n"
end

def create_relations
  users = User.all
  user  = User.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }

  # prompt to shell
  puts "#{"*" * 23}\r\nRelations are created!\r\n"
end
