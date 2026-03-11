User.create!(
    name: "Felix Red",
    email: "felix@glucode.com",
    password: "Password@10",
    password_confirmation: "Password@10",
    admin: true
)

99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@glucode.com"
    password = "foobar"
    User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password
)
end
