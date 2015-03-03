%w(member admin superadmin).each do |role|
  User.where(email: "#{role}@email.com").first_or_create do |u|
    u.password = 'seshook123'
    u.password_confirmation = 'seshook123'
    u.role = role
  end
end

%w(Web Mobile).each do |name|
  FactoryGirl.create(:application, name: name)
end

(1..100).each do |i|
  %i(user spot).each do |model|
    FactoryGirl.create(model, created_at: rand(365).days.ago.to_date)
    FactoryGirl.create(model, created_at: rand(365).days.ago.to_date)
  end
end
