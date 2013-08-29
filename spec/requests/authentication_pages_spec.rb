# encoding: utf-8

require 'spec_helper'

describe "Авторизация:" do
	subject {page}  

	describe "страница ВХОДА" do
		before {visit signin_path}

		# Проверяем наличие стандартных атрибутов на странице
		it { should have_selector('h1', text:"Вход в систему") }
		it { should have_selector('title', text: "Вход в систему") }

		# Проверяем реакцию на НЕ правильные данные
		describe "с введенными не правильными данными" do
			before {click_button "Вход в систему"}

			it { should have_selector('title', text: "Вход в систему") }
			it { should have_selector('div.alert.alert-error',  text: "Не верная комбинация логин/пароль") }

			describe "посещение другой страницы после отправки логина/пароля" do

			end
		end

		# Проверяем реакцию на ПРАВИЛЬНЫЕ данные
		describe "с введенными правильными данными" do
			let (:user) {FactoryGirl.create(:user)}
			before do
				fill_in "Email",		with: user.email.upcase
				fill_in	"Пароль", 	with: user.password
				click_button "Вход в систему"

				it { should have_selector('title', 	text: user.name) }
				it { should have_link('Профиль', 		href: user_path(user)) }
				it { should have_link('Выход', 			href: signout_path) }
				it { should_not have_link('Вход', 	href: signin_path) }
			end
		end
	end
end
