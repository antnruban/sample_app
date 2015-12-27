namespace :db do
  desc "Fill database with sample users data"
  task populate: :environment do
    User.create!(name: "Admin User",
                 email: "firstadmin@post.dom",
                 password: "password",
                 password_confirmation: "password",
                 admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "name-#{n+1}@post.dom"
      password  = "password"
      user = User.create!(name: name,
                          email: email,
                          password: password,
                          password_confirmation: password)
    end

    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content ) }
    end
  end
end
