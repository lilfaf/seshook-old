# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

%w(user admin superadmin).each do |role|
  User.where(email: "#{role}@email.com").first_or_create do |u|
    u.password = 'seshook123'
    u.password_confirmation = 'seshook123'
    u.role = role
  end
end
