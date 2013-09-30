# encoding: utf-8

namespace :db do
	desc "Наполнение базы данных данными для примера"
	task populate: :environment do
		admin = User.create!(name: "Пользователь для примера",
												 email: "example@railstutorial.org",
								 				 password: "foobar",
												 password_confirmation: "foobar")
		admin.toggle!(:admin)
		
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "password"
			User.create!(name: 	name,
									 email: email,
									 password: password,
									 password_confirmation: password)
		end

		user = User.all(limit: 6)
		50.times do
			content = Faker::Lorem.sentence(5)
			user.each { |user|  user.microposts.create!(content: content) }
		end
	end
end