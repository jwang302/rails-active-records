# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
require 'digest/sha1'

users = [
  { first_name: 'Carly', last_name: 'Fiorina', birth_year: 1954, gender: 'female' },
  { first_name: 'Donald', last_name: 'Trump', birth_year: 1946, gender: 'male' },
  { first_name: 'Ben', last_name: 'Carson', birth_year: 1951, gender: 'male' },
  { first_name: 'Hillary', last_name: 'Clinton', birth_year: 1947, gender: 'female' }
]

users.each do |user|
  u = User.create(
    username: user[:last_name],
    password_digest: Digest::SHA1.hexdigest(user[:first_name])
  )
  u.create_profile(
    first_name: user[:first_name],
    last_name: user[:last_name],
    birth_year: user[:birth_year],
    gender: user[:gender]
  )

  due_date = Date.today.next_year(1)
  todo_list = u.to_do_lists.create(
    list_name: "#{user[:last_name]}_list",
    list_due_date: due_date
  )

  5.times do |i|
    todo_list.to_do_items.create(
      due_date: due_date,
      description: "#{user[:last_name]}_item_#{i}"
    )
  end
end
