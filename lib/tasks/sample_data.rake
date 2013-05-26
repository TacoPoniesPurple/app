namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Jack Sparrow",
                         email: "jays@pirates.arr",
                         password: "foobar",
                         password_confirmation: "foobar")
    admin.toggle!(:admin)
    User.create!(name: "Hazel Feathers",
                 email: "hazel@feathers.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = "usuario-#{n+1}@feathers.com"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end